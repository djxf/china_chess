


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


    //逐个绘制棋子
    final textStyle = TextStyle(
      color: Constants.PieceTextColor,
      fontSize: piecesSide * 0.8,
      height: 1.0
    );

    piecesToDraw.forEach((it) {

      paint.color = Piece.isRed(it.piece) ? Constants.RedPieceBorderColor : Constants.BlackPieceBorderColor;

      //绘制棋子的边界
      canvas.drawCircle(it.pos, piecesSide/2, paint);

      paint.color = Piece.isRed(it.piece) ? Constants.BlackPieceBorderColor:Constants.RedPieceBorderColor;
      //绘制棋子的内部圆
      canvas.drawCircle(it.pos, piecesSide * 0.8 / 2, paint);

      //绘制文字
      final textSpan = TextSpan(text: Piece.Names[it.piece],
        style: textStyle
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr
      )..layout();

      //计算字体的Metrics， 包含相应字体的Baseline。
      final metrics = textPainter.computeLineMetrics()[0];

      //测量字体的尺寸
      final textSize = textPainter.size;

      //从顶上算，文字的BaseLine 在 2/3 的高度线上。
      final textOffset = it.pos - Offset(textSize.width / 2, metrics.baseline - textSize.height / 3);
      //final textOffset = it.pos;
      //将文字绘制到canvas上
      textPainter.paint(canvas, textOffset);







    });


  }



}

//棋子绘制子类
class PiecePaintStub {
  final String piece;
  final Offset pos; //棋子的呈现位置

  PiecePaintStub({this.piece, this.pos});
}
