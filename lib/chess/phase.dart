

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

}