import 'dart:html';

import 'package:china_chess/BattlePage.dart';
import 'package:china_chess/routes/main_menu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());

  if () {

  }
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'KaiTi',
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent
      ),
      home: MainMenu(),
    );
  }
}


