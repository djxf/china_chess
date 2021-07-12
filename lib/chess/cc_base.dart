


import 'package:flutter/cupertino.dart';

class Side {


  static const Unknown = '-';
  static const Red = 'w'; //红
  static const Black = 'b'; //黑

  static String of(String piece) {
    if('RNBAKCP'.contains(piece)) return Red;
    if('rnbakcp'.contains(piece)) return Black;
    return Unknown;
  }


  static bool sameSide(String p1, String p2) {
    return of(p1) == of(p2);
  }

  static String oppo(String side) {
    if (side == Red) return Black;
    if (side == Black) return Red;
    return side;
  }
}