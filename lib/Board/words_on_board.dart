

import 'package:flutter/cupertino.dart';

class WordsOnBoard extends StatelessWidget {


  static const double DigitsFontSize = 18.0;


  @override
  Widget build(BuildContext context) {


    final blackColumms = '123456789';
    final redColumns = '九八七六五四三二一';
    final bChildren = <Widget>[];
    final rChildren = <Widget>[];

    final digitsStyle = TextStyle(fontSize: DigitsFontSize);
    final rivierTipsStyle = TextStyle(fontSize: 28.0, fontFamily: 'KaiTi');

    for(var i = 0; i < 9; i++) {
      bChildren.add(Text(blackColumms[i], style: digitsStyle,));
      rChildren.add(Text(redColumns[i], style: digitsStyle,));
    }

    final r = Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: rChildren,
    );
    final b = Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: bChildren,
    );
    final riverTips = Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('楚河', style: rivierTipsStyle),
        Text('汉界', style: rivierTipsStyle),
      ],
    );



    return Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          r,
          riverTips,
          b,
        ],
    );
  }
}
