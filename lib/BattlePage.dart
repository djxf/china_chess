
import 'package:china_chess/Board/BoardWidget.dart';
import 'package:china_chess/Constants.dart';
import 'package:china_chess/chess/battle.dart';
import 'package:china_chess/chess/cc_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/**
 * Phase局面对象应该被谁持有?
 *  :避免传递链路过长，构造一个全局单例对象。
 *
 */

class BattlePage extends StatefulWidget {
  const BattlePage({Key key}) : super(key: key);

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {


  //由BattlePage的state来处理棋盘的逻辑
  onBoardTap(BuildContext context, int pos) {
    print("board cross index: $pos");

    final phase = Battle.shared.phase;

    //当前走子方
    var cruSide = phase.side;
    final tapPiece = phase.pieceAt(pos);
    print("cruSide: $cruSide, tapPieceSide: ${Side.of(tapPiece)}");

    //1 是否轮到当前棋子方行棋。
    if (Battle.shared.focusIndex == -1 && Side.of(tapPiece) != cruSide) {
      return;
    }

    // Side.of(phase.pieceAt(Battle.shared.focusIndex)) == Side.Red

    //之前有棋子被选中了。
    if (Battle.shared.focusIndex != -1) {
      print("有棋子被选中, pos: $pos");
      //当前点击的棋子和之前选择的棋子是同一个位置
      if (Battle.shared.focusIndex == pos) {
        print("选中的棋子是同一个棋子");
        return;
      }

      //之前的选择的棋子和选择的棋子是一边的，说明是选择另外一个棋子
      final focusPiece = phase.pieceAt(Battle.shared.focusIndex);

      if (Side.sameSide(focusPiece, tapPiece)) {
          Battle.shared.select(pos);
      } else if (Battle.shared.move(Battle.shared.focusIndex, pos)) {
        //tode: 吃子或者移动到空白处

      }

    } else {
      //之前未选子，现在点击就是选择棋子
      print("有棋子未被选中, pos: $pos");
      if (tapPiece != Piece.Empty) {
        Battle.shared.select(pos);
      }
    }

    setState(() {
      print("重绘");
    });
  }


  @override
  void initState() {
    Battle.shared.init();
  }

  @override
  Widget build(BuildContext context) {

    //window
    final Size windowSize = MediaQuery.of(context).size;
    final boardWidth = windowSize.width - Constants.PaddingOfBorad * 2;
    return Scaffold(
      appBar: AppBar(title: Text("对战"), centerTitle: true,),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: Constants.BoardMarginH,
          vertical: Constants.BoardMarginV
        ),
        child: BoardWidget(width: boardWidth, onBoardTap: onBoardTap,),
      ),
    );
  }
}
