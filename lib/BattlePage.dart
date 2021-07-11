
import 'package:china_chess/Board/BoardWidget.dart';
import 'package:china_chess/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BattlePage extends StatelessWidget {
  const BattlePage({Key key}) : super(key: key);




  @override
  Widget build(BuildContext context) {

    //window
    final Size windowSize = MediaQuery.of(context).size;
    final boardWidth = windowSize.width - Constants.PaddingOfBorad * 2;
    return Scaffold(
      appBar: AppBar(title: Text("对战"),),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: Constants.BoardMarginH,
          vertical: Constants.BoardMarginV
        ),
        child: BoardWidget(width: boardWidth,),
      ),
    );
  }
}
