

import 'package:china_chess/chess/cc_base.dart';

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

    get side => _side;

    //转换行棋方
    trunSide() => _side = Side.oppo(_side);

    //查询位置
    String pieceAt(int index) => _pieces[index];

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

        return true;
    }

    //验证走子是否合法
    bool validateMove(int from, int to) {
        //TODO
        return true;
    }

    //默认构造方法
    Phase.defaultPhase() {
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


        //从上到下 棋盘第三行
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

}