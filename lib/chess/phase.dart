

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

    get side => _side;

    //转换行棋方
    trunSide() => _side = Side.oppo(_side);

    //查询位置
    String pieceAt(int index) => _pieces[index];


    //命名构造方法
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

}