
import 'dart:math';

import 'package:china_chess/Board/BoardWidget.dart';
import 'package:china_chess/Board/painter_base.dart';
import 'package:china_chess/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoardPaint extends PainterBase{

  BoardPaint({@required double width}) : super(width: width);

  @override
  void paint(Canvas canvas, Size size) {
      doPaint(canvas, thePaint, gridWidth, squareSide, offsetx: squareSide/2 + Constants.BoardMarginH,offsety: Constants.DigitsHeight + squareSide / 2 + Constants.BoardMarginV);
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
      canvas.drawRect(Rect.fromLTRB(left, top, gridWidth + left, top + squareSize * 9),
          paint);

      //中轴线
      paint.strokeWidth = 1;
      canvas.drawLine(
          Offset(left + gridWidth/2, top),
          Offset(left + gridWidth/2, top + squareSize * 9), paint);

      //8根中间的横线
      for(var i = 1; i <= 8; i++) {
        canvas.drawLine(Offset(left, squareSize * i + top),
                        Offset(left + gridWidth, squareSize * i + top), paint);
      }

      //上下各6根竖线
      for(var i = 1; i < 8; i++) {
        if (i == 4) {
          continue;
        }
        canvas.drawLine(Offset(left + squareSize * i, top),
            Offset(left + squareSize * i, top + squareSize * 4), paint);
        canvas.drawLine(Offset(left + squareSize * i, top + squareSize * 5),
            Offset(left + squareSize * i, top + squareSize * 9), paint);
      }

      //九宫格4根斜线
      canvas.drawLine(Offset(left + squareSize * 3, top),
          Offset(left + squareSize * 5, top + squareSize * 2), paint);
      canvas.drawLine(Offset(left + squareSize * 5, top),
          Offset(left + squareSize * 3, top + squareSize * 2), paint);

      canvas.drawLine(Offset(left + squareSize * 3, top + squareSize * 9),
          Offset(left + squareSize * 5, top + squareSize * 7), paint);
      canvas.drawLine(Offset(left + squareSize * 5, top + squareSize * 9),
          Offset(left + squareSize * 3, top + squareSize * 7), paint);


      //炮兵位置标识
    final positions = [
      Offset(left + squareSize, top + squareSize * 2),
      Offset(left + squareSize * 7, top + squareSize * 2),
      Offset(left + squareSize, top + squareSize * 7),
      Offset(left + squareSize * 7, top + squareSize * 7),
      // 部分兵架位置指示
      Offset(left + squareSize * 2, top + squareSize * 3),
      Offset(left + squareSize * 4, top + squareSize * 3),
      Offset(left + squareSize * 6, top + squareSize * 3),
      Offset(left + squareSize * 2, top + squareSize * 6),
      Offset(left + squareSize * 4, top + squareSize * 6),
      Offset(left + squareSize * 6, top + squareSize * 6),

    ];

    positions.forEach((pos) {
          canvas.drawCircle(pos, 5, paint);
    });

      // 兵架靠边位置指示
      final leftPositions = [
        Offset(left, top + squareSize * 3),
        Offset(left, top + squareSize * 6),
      ];
      leftPositions.forEach((pos) {
        var rect = Rect.fromCenter(center: pos, width: 10, height: 10);
        canvas.drawArc(rect, -pi / 2, pi, true, paint);
      });

      final rightPositions = [
        Offset(left + gridWidth, top + squareSize * 3),
        Offset(left + gridWidth, top + squareSize * 6)
      ];
      rightPositions.forEach((pos) {
          var rect = Rect.fromCenter(center: pos, width: 10, height: 10);
          canvas.drawArc(rect, pi / 2 , pi, false, paint);
      });

  }









}