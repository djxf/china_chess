


import 'package:flutter/cupertino.dart';

import '../Constants.dart';

abstract class PainterBase extends CustomPainter {


  final double width;
  final double gridWidth;
  final double squareSide;

  final Paint thePaint = Paint();

  PainterBase({this.width}) :
        gridWidth = (width - Constants.BoardMarginH * 2) * 8 / 9,
        squareSide = (width - Constants.BoardMarginH * 2) / 9;
}