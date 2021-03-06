

import 'package:china_chess/chess/cc_base.dart';
import 'package:china_chess/chess/steps-validate.dart';

/**
 *
 *
 * 局面信息
 *
 * 棋子的宽度  =  棋子中一个格子的宽度 * 0.90
 *
 *
 *
 */

class Phase {

    //当前行棋方
    String _side;

    //90个位置
    List<String> _pieces;

    //无吃子步数，总回合数
    int halfMove = 0, fullMove = 0;

    //对局结果字段
    BattleResult result = BattleResult.Pending;

    get side => _side;

    //转换行棋方
    trunSide() => _side = Side.oppo(_side);

    //查询位置
    String pieceAt(int index) => _pieces[index];

    //
    String lastCapturedPhase;

    String captured;

    final _history = <Move>[];

    //移动棋子
    bool move(int from, int to) {
        if (!validateMove(from, to)) return false;


        //记录无吃子步数
        if (_pieces[to] != Piece.Empty) {
            halfMove = 0;
        } else {
            halfMove++;
        }

        // 和总回合数
        if (fullMove == 0) {
            fullMove++;
        } else if (side == Side.Black) {
            fullMove++;
        }

        //1 修改棋盘
        _pieces[to] = _pieces[from];
        _pieces[from] = Piece.Empty;

        //2 交换走子方
        _side = Side.oppo(_side);

        //TODO: capture字段来源
        _history.add(Move(from, to, captured: captured));
        if (captured != Piece.Empty) {
            lastCapturedPhase = toFen();
        }
        return true;
    }

    //测试移动方法,需要在克隆的棋盘上进行行棋假设
    void moveTest(Move move, {turnSide = false}) {
        _pieces[move.to] = _pieces[move.from];
        _pieces[move.from] = Piece.Empty;

        if (trunSide()) _side = Side.oppo(_side);
    }

    //验证走子是否合法
    bool validateMove(int from, int to) {
        if (Side.of(_pieces[from]) != _side) return false;
        return (StepValidate.validate(this, Move(from, to)));
    }

    void initDefaultPhase() {
        _side = Side.Red;
        _pieces = List<String>(90);

        //从上到下 棋盘第一行
        _pieces[0 * 9 + 0] = Piece.BlackRook;
        _pieces[0 * 9 + 1] = Piece.BlackKnigt;
        _pieces[0 * 9 + 2] = Piece.BlackBishop;
        _pieces[0 * 9 + 3] = Piece.BlackAdvisor;
        _pieces[0 * 9 + 4] = Piece.BlackKing;
        _pieces[0 * 9 + 5] = Piece.BlackAdvisor;
        _pieces[0 * 9 + 6] = Piece.BlackBishop;
        _pieces[0 * 9 + 7] = Piece.BlackKnigt;
        _pieces[0 * 9 + 8] = Piece.BlackRook;


        //从上到下棋盘第三行
        _pieces[2 * 9 + 1] = Piece.BlackCanon;
        _pieces[2 * 9 + 7] = Piece.BlackCanon;

        //从上倒下 棋盘第四行
        _pieces[3 * 9 + 0] = Piece.BlackPawn;
        _pieces[3 * 9 + 2] = Piece.BlackPawn;
        _pieces[3 * 9 + 4] = Piece.BlackPawn;
        _pieces[3 * 9 + 6] = Piece.BlackPawn;
        _pieces[3 * 9 + 8] = Piece.BlackPawn;


        //从上到下  棋盘第七行
        _pieces[6 * 9 + 0] = Piece.RedPawn;
        _pieces[6 * 9 + 2] = Piece.RedPawn;
        _pieces[6 * 9 + 4] = Piece.RedPawn;
        _pieces[6 * 9 + 6] = Piece.RedPawn;
        _pieces[6 * 9 + 8] = Piece.RedPawn;

        //从上到下 棋盘第八行
        _pieces[7 * 9 + 1] = Piece.RedCanon;
        _pieces[7 * 9 + 7] = Piece.RedCanon;

        //从上到下 棋盘第十行
        _pieces[9 * 9 + 0] = Piece.RedRook;
        _pieces[9 * 9 + 1] = Piece.RedKnigt;
        _pieces[9 * 9 + 2] = Piece.RedBishop;
        _pieces[9 * 9 + 3] = Piece.RedAdvisor;
        _pieces[9 * 9 + 4] = Piece.RedKing;
        _pieces[9 * 9 + 5] = Piece.RedAdvisor;
        _pieces[9 * 9 + 6] = Piece.RedBishop;
        _pieces[9 * 9 + 7] = Piece.RedKnigt;
        _pieces[9 * 9 + 8] = Piece.RedRook;

        //其他位置全部填空
        for(var i = 0; i < 90; i++) {
            _pieces[i] ??= Piece.Empty;
        }

        lastCapturedPhase = toFen();
    }



    //默认构造方法
    Phase.defaultPhase() {
        initDefaultPhase();
    }

    //根据局面数据生成局面表示字符串(FEN)
    String toFen() {

        var fen = '';
        for( var row = 0; row < 10; row++) {

            var emptyCounter = 0;

            for(var column = 0; column < 9; column++) {
                final piece = pieceAt(row * 9 + column);

                if (piece == Piece.Empty) {
                    emptyCounter++;
                } else {
                    if (emptyCounter > 0) {
                        fen += emptyCounter.toString();
                        emptyCounter = 0;
                    }
                    fen += piece;
                }
            }
            if (emptyCounter > 0) {
                fen += emptyCounter.toString();
            }

            if (row < 9) {
                fen += '/';
            }
        }
        fen += ' $side';

        //王车易位和吃过路兵标志
        fen += ' - - ';

        //step counter
        fen += '$halfMove $fullMove';

        return fen;
    }

    Phase.clone(Phase other) {

        _pieces = List<String>();

        other._pieces.forEach((it) {
            _pieces.add(it);
        });

        _side = other._side;
        halfMove = other.halfMove;
        fullMove = other.fullMove;
    }

    //
    String movesSinceLastCaptured() {

        var steps = '';
        var posAfterLastCaptured = 0;
        for (var i = _history.length - 1; i >= 0; i--) {
            if (_history[i].captured != Piece.Empty) {
                break;
            }
            posAfterLastCaptured = i;
        }

        for (var i = posAfterLastCaptured; i < _history.length; i++) {
            steps += ' ${_history[i].step}';
        }
        //TODO: steps.substring(1)???
        return steps.length > 0 ? steps.substring(1) : '';
    }

}