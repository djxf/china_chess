


import 'package:china_chess/Board/painter_base.dart';
import 'package:china_chess/Constants.dart';
import 'package:flutter/cupertino.dart';

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

class PiecesPainter extends PainterBase {

  PiecesPainter({@required double width}) : super(width: width);

  @override
  void paint(Canvas canvas, Size size) {

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }



}
