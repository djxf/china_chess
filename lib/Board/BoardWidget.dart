

import 'package:china_chess/Board/borad_paint.dart';
import 'package:china_chess/Board/piece_painter.dart';
import 'package:china_chess/Board/words_on_board.dart';
import 'package:china_chess/Constants.dart';
import 'package:china_chess/chess/battle.dart';
import 'package:flutter/cupertino.dart';

class BoardWidget extends StatelessWidget {


  //棋盘的宽高
  final double width, height;

  //棋盘的点击事件回调
  final Function(BuildContext, int) onBoardTap;


  BoardWidget({@required this.width, @required this.onBoardTap}) :
      height = (width - Constants.BoardMarginH * 2) / 9 * 10 + (Constants.BoardMarginV + Constants.DigitsHeight) * 2;


  @override
  Widget build(BuildContext context) {

    final boardContainer = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Constants.BoardBackground,
      ),
      child: CustomPaint(
        painter: BoardPaint(width: this.width),
        foregroundPainter: PiecesPainter(
            width: this.width,
            phase: Battle.shared.phase,
            focusIndex: Battle.shared.focusIndex,
            blurIndex: Battle.shared.blurIndex
        ),
        child: Container(
          child: WordsOnBoard(),
        ),
      ),
    );

     return GestureDetector(
       child: boardContainer,
       onTapUp: (d) {

         final gridWidth = (width - Constants.PaddingOfBorad * 2) * 8 /9;
         final squareSide = gridWidth / 8;

         final dx = d.localPosition.dx;
         final dy = d.localPosition.dy;

         //棋盘上的行列转换
         final row = (dy - Constants.PaddingOfBorad - Constants.DigitsHeight) ~/ squareSide;

         final column = (dx - Constants.PaddingOfBorad) ~/ squareSide;
         print("行： $row， 列：$column");
         if (row < 0 || row > 9) return;
         if (column < 0 || column > 8) return;

        //回调
         onBoardTap(context, row * 9 + column);

       },
     );
  }

}