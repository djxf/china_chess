
import 'package:china_chess/Board/BoardWidget.dart';
import 'package:china_chess/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoardPaint extends CustomPainter{

    //棋盘的宽度，棋盘上线格的总宽度，每一个格子的边长
    final double width,gridWidth,squareSize;
    final thePaint = Paint();

    BoardPaint({@required this.width}) :
        gridWidth = (width - Constants.BoardMarginH * 2) / 9 * 8,
          squareSize = (width - Constants.BoardMarginH * 2) / 9;

  @override
  void paint(Canvas canvas, Size size) {
      doPaint(canvas, thePaint, gridWidth, squareSize, offsetx: Constants.PaddingOfBorad + squareSize  + Constants.BoardMarginH,offsety: Constants.PaddingOfBorad + Constants.DigitsHeight + squareSize / 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
      //返回true则始终重绘
    return true;
  }


  static void doPaint(
      Canvas canvas,
      Paint paint,
      double gridWidth,
      double squareSize,{
        double offsetx,
        double offsety,
      }
      ) {

      paint.color = Constants.BoardLine;
      paint.style = PaintingStyle.stroke;

      var left = offsetx;
      var top = offsety;
      //外框
      paint.strokeWidth = 2;
      canvas.drawRect(Rect.fromLTRB(left, top, gridWidth, squareSize * 9),
          paint);

      //中轴线
      paint.strokeWidth = 1;
      canvas.drawLine(
          Offset(left + gridWidth/2, top),
          Offset(left + gridWidth/2, top + squareSize * 9), paint);




  }









}