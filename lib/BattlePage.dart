
import 'package:china_chess/Board/BoardWidget.dart';
import 'package:china_chess/Constants.dart';
import 'package:china_chess/chess/battle.dart';
import 'package:china_chess/chess/cc_base.dart';
import 'package:china_chess/chess/chess_road.dart';
import 'package:china_chess/engine/clound-engine.dart';
import 'package:china_chess/engine/engine.dart';
import 'package:china_chess/engine/native-engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


/**
 * Phase局面对象应该被谁持有?
 *  :避免传递链路过长，构造一个全局单例对象。
 *
 */

class BattlePage extends StatefulWidget {

  BattlePage(this.engineType): engine = ((engineType == EngineType.Cloud) ? CloudEngine() : NativeEngine());

  final EngineType engineType;
  final AiEngine engine;

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {


  //状态说明
  String _status = '';

  changeStatus(String status) => setState(() {
    _status = status;
  });

  newGame() {

    confirm() {
      Navigator.of(context).pop();
      Battle.shared.newGame();
      setState(() { });
    }

    cancle() => Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('放弃对局？', style: TextStyle(color: Constants.PrimaryColor),),
          actions: [
            TextButton(onPressed: confirm, child: Text("确定")),
            TextButton(onPressed: cancle, child: Text("取消")),
          ],
        );
      }
    );
  }

  engineToGO() async {

    changeStatus("对方正在思考中...");

    final response = await widget.engine.search(Battle.shared.phase);

    if (response.type == 'move') {

      final step = response.value;
      Battle.shared.move(step.from, step.to);

      final result = Battle.shared.scanBattleResult();

      switch (result) {
        case BattleResult.Pending:
          changeStatus("请走棋...");
          break;
        case BattleResult.Win:
          getWin();
          break;
        case BattleResult.Lose:
          getLose();
          break;
        case BattleResult.Draw:
          getDraw();
          break;
      }
    } else {
      changeStatus("Error: ${response.type}");
    }

  }

  //由BattlePage的state来处理棋盘的逻辑
  onBoardTap(BuildContext context, int pos) {
    print("board cross index: $pos");

    final phase = Battle.shared.phase;
    print("当前局面：${phase.toFen()} ");

    //当前走子方
    var cruSide = phase.side;
    final tapPiece = phase.pieceAt(pos);
    print("cruSide: $cruSide, tapPieceSide: ${Side.of(tapPiece)}");

    //1 是否轮到当前棋子方行棋。
    if (Battle.shared.focusIndex == -1 && Side.of(tapPiece) != cruSide) {
      print("行棋方错误");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("当前行棋方为： ${(cruSide == Side.Red) ? "黑":"红"}"),
      ));
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
        //TODO: 吃子或者移动到空白处
        //
        final result = Battle.shared.scanBattleResult();

        switch (result) {
          case BattleResult.Pending:
          // 玩家走一步棋后，如果游戏还没有结束，则启动引擎走棋
            engineToGO();
            break;
          case BattleResult.Win:
            getWin();
            break;
          case BattleResult.Lose:
            getLose();
            break;
          case BattleResult.Draw:
            getDraw();
            break;
        }
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
    super.initState();
    Battle.shared.init();

    //启动引擎
    widget.engine.startup();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  void didUpdateWidget(covariant BattlePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  //网络请求之类，如果放在build方法之内将会十分耗费资源。
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }


  //remove from the tree,
  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    widget.engine.shutdown();
  }

  @override
  Widget build(BuildContext context) {

    final header = createPageHeader();
    final board = createBoard();
    final operatorBar = createOperatorBar();

    return Scaffold(
      backgroundColor: Constants.DarkBackground,
      body: Column(
        children: [
          header, board, operatorBar
        ],
      ),
    );

  }


  Widget createPageHeader() {

    final textStyle = TextStyle(
      fontSize: 28,
      color: Constants.DarkTextPrimary,
    );

    final subTitleStyle = TextStyle(
      fontSize: 16,
      color: Constants.DarkTextSecondary
    );

    return Container(
      margin: EdgeInsets.only(top: ChessRoadApp.StatusBarHeight),
      child: Column(
        children: [
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
                Navigator.pop(context);
              }, color: Constants.DarkTextPrimary,),
              Text(widget.engineType == EngineType.Cloud ? '挑战云主机' : '单机对战', style: textStyle),
              IconButton(
                icon: Icon(Icons.settings, color: Constants.DarkTextPrimary,),
                onPressed: () {},
              )
            ],
          ),
          Container(
            height: 4,
            width: 180,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Constants.BoardBackground,
              borderRadius: BorderRadius.circular(2)
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("[$_status]", maxLines: 1, style: subTitleStyle,),
          )
        ],
      ),
    );
  }

  Widget createBoard() {
    //window
    final Size windowSize = MediaQuery.of(context).size;
    final boardWidth = windowSize.width - Constants.PaddingOfBorad * 2;
    return Container(
        margin: const EdgeInsets.symmetric(
            horizontal: Constants.BoardMarginH,
            vertical: Constants.BoardMarginV
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Constants.BoardBackground
        ),
        child: BoardWidget(width: boardWidth, onBoardTap: onBoardTap,),
      );
  }

  //操作菜单栏
  Widget createOperatorBar() {

    final buttonStyle = TextStyle(color: Constants.DarkTextSecondary, fontSize: 20);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Constants.BoardBackground,
      ),
      margin: EdgeInsets.symmetric(horizontal: Constants.BoardMarginH),
      child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(onPressed: newGame, child: Text("新对局", style: buttonStyle,)),
            TextButton(onPressed: () {}, child: Text("悔棋", style: buttonStyle,)),
            TextButton(onPressed: () {}, child: Text("分析局面", style: buttonStyle,)),
          ],
        ),
    );
  }

  //显示胜利框
  void getWin() {

    Battle.shared.phase.result = BattleResult.Win;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("胜利", style: TextStyle(color: Colors.black),),
            content: Text('恭喜你取得胜利！'),
            actions: [
              TextButton(onPressed: newGame, child: Text("再来一盘")),
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text("关闭")),
            ],
          );
        });
  }


  //显示失败框
  void getLose() {

    Battle.shared.phase.result = BattleResult.Lose;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("失败", style: TextStyle(color: Colors.black),),
            content: Text('需要继续加油！'),
            actions: [
              TextButton(onPressed: newGame, child: Text("再来一盘")),
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text("关闭")),
            ],
          );
        });
  }

  //显示和棋框
  void getDraw() {
    Battle.shared.phase.result = BattleResult.Draw;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('和了', style: TextStyle(color: Colors.black)),
          content: Text('您用自己的力量捍卫了和平！'),
          actions: <Widget>[
            TextButton(child: Text('再来一盘'), onPressed: newGame),
            TextButton(child: Text('关闭'), onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }
  }




