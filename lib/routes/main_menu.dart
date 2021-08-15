

import 'package:china_chess/BattlePage.dart';
import 'package:china_chess/chess/chess_road.dart';
import 'package:china_chess/engine/engine.dart';
import 'package:china_chess/engine/native-engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    final nameStyle = TextStyle(
      fontSize: 64,
      color: Colors.black
    );

    final menuItemStyle = TextStyle(
      fontSize: 28,
      color: Colors.black,
    );

    //标题及菜单的布局
    final menuItem = Center(
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("中国象棋", style: nameStyle, textAlign: TextAlign.center,),
            TextButton(onPressed: () {
              MaterialPageRoute(builder: (context) => BattlePage(EngineType.Native));
            }, child: Text("单机对战", style: menuItemStyle)),
            TextButton(onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BattlePage(EngineType.Cloud)),
              );
            }, child: Text("挑战云主机", style: menuItemStyle)),
            TextButton(onPressed: () {}, child: Text("排行榜", style: menuItemStyle)),
          ],
        ),
    );


    return Scaffold(
      backgroundColor: Constants.LightBackground,
      body: Stack(
        children: [
          menuItem,
          Positioned(
            top: ChessRoadApp.StatusBarHeight,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.settings, color: Constants.PrimaryColor,),
              onPressed: () {},
            ),
          ),
          Positioned.fill(
             bottom: 20,
             child: Align(
               alignment: Alignment.bottomCenter,
               child:Text("用心娱乐， 为爱传承", style: TextStyle(color: Colors.black54, fontSize: 16))
             ),
          )
        ],
      ),
    );
  }
}
