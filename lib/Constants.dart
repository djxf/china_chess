
import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {


  static const LogoColor = Color(0xFF6D000D);

  static const PrimaryColor = Color(0xFF61220);

  // 辅助色
  static const Secondary = Color(0x99461220);

  // 深色背景
  static const DarkBackground = Colors.brown;
  // 浅色背景
  static const LightBackground = Color(0xFFEEE0CB);

  // 棋盘颜色
  static const BoardBackground = Color(0xFFEBC38D);

  static const DarkTextPrimary = Colors.white;
  static const DarkTextSecondary = Color(0x99FFFFFF);

  // 棋盘线颜色
  static const BoardLine = Color(0x996D000D);

  // 棋盘上的路数、河界提示文字颜色
  static const BoardTips = Color(0x666D000D);

  static const LightLine = Color(0x336D000D);

  // 棋盘上的移动位置指示
  static const FocusPosition = Color(0x99FFFFFF);
  static const BlurPosition = Color(0x99FFFFFF);

  // 黑棋子颜色
  static const BlackPieceColor = Color.fromARGB(0xFF, 0x00, 0x00, 0x00);
  static const BlackPieceBorderColor = Color.fromARGB(0xFF, 0x22, 0x22, 0x22);

  // 红棋子颜色
  static const RedPieceColor = Color.fromARGB(0xFF, 0x7B, 0x00, 0x00);
  static const RedPieceBorderColor = Color.fromARGB(0xFF, 0x66, 0x00, 0x00);

  // 棋子文字颜色
  static const PieceTextColor = Color.fromARGB(0xCC, 0xFF, 0xFF, 0xFF);

  //位置定位常量
  static const PaddingOfBorad = 10.0;



  //棋盘纵横方向上的边距
  static const BoardMarginV = 10.0, BoardMarginH = 10.0;


  //棋盘上的路数指定文字高度
  static const double DigitsHeight = 36.0;



}