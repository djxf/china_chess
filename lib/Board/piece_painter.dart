


import 'package:china_chess/Board/painter_base.dart';
import 'package:china_chess/Constants.dart';
import 'package:china_chess/chess/cc_base.dart';
import 'package:china_chess/chess/phase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * 共同逻辑的抽象和复用。
 *
 *
 */


/**
 *
 * dart语法中子类构造函数和父类构造的关系？
 * 子类可以直接调用父类的构造函数吗？
 *
 *
 */


/***
 *
 * 绘制棋子的步骤：
 *      1 绘制棋子大小相同的阴影，阴影要放在其他绘图之外。
 *      2 区分棋子的颜色，填充指定大小的圆。
 *      3 区分棋子的颜色在代表棋子的圆外添加一个圆圈边框
 *      4 在棋盘的圆圈中间，区分颜色写上代表棋子的文字。
 *
 *
 *
 *
 */

class PiecesPainter extends PainterBase {



  //当前局面
  final Phase phase;
  //棋子宽度
  double pieceSide;


  PiecesPainter({@required double width, @required this.phase}) : super(width: width) {

    pieceSide = squareSide * 0.9;
  }

  @override
  void paint(Canvas canvas, Size size) {
      doPaint(canvas, thePaint, phase: phase, gridWidth: gridWidth,
      squareSide: squareSide,piecesSide: pieceSide,
        offsetX: Constants.PaddingOfBorad + squareSide /2,
        offsetY: Constants.PaddingOfBorad + Constants.DigitsHeight + squareSide /2
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }


  static doPaint(
      Canvas canvas,
      Paint paint, {
        Phase phase,
        double gridWidth,
        double squareSide,
        double piecesSide,
        double offsetX,
        double offsetY
      }) {

    final left = offsetX;
    final top = offsetY;

    final shadowPath = Path();
    final piecesToDraw = <PiecePaintStub>[];

    for(var row = 0; row < 10; row++) {

      for(var column = 0; column < 9; column++) {

        final piece = phase.pieceAt(row * 9 + column);
        if (piece == Piece.Empty) continue;

        var pos = Offset(left + squareSide * column, top + squareSide * row);
        piecesToDraw.add(PiecePaintStub(pos: pos, piece: piece));

        shadowPath.addOval(
          Rect.fromCenter(center: pos, width: piecesSide, height: piecesSide)
        );
        
      }
    }

    canvas.drawShadow(shadowPath, Colors.black, 2, true);



  }



}

//棋子绘制子类
class PiecePaintStub {
  final String piece;
  final Offset pos; //棋子的呈现位置

  PiecePaintStub({this.piece, this.pos});
}
