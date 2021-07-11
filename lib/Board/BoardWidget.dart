
import 'dart:ffi';

import 'package:china_chess/Board/borad_paint.dart';
import 'package:china_chess/Board/words_on_board.dart';
import 'package:china_chess/Constants.dart';
import 'package:flutter/cupertino.dart';

class BoardWidget extends StatelessWidget {


  //棋盘的宽高
  final double width, height;

  BoardWidget({@required this.width}) :
      height = (width - Constants.BoardMarginH * 2) / 9 * 10 + (Constants.BoardMarginV + Constants.DigitsHeight) * 2;


  @override
  Widget build(BuildContext context) {
     return Container(
       width: width,
       height: height,
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(5),
         color: Constants.BoardBackground,
       ),
       child: CustomPaint(
         painter: BoardPaint(width: this.width),
         child: Container(
           child: WordsOnBoard(),
         ),
       ),
     );
  }

}