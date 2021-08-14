import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:china_chess/chess/phase.dart';
import 'package:china_chess/engine/clound-engine.dart';
import 'package:flutter/material.dart';

/**
 *
 *
 * 与云库通信的引擎，
 * 象棋局面：
 *
 *
 */

class ChessDB {


  static const Host = 'www.chessdb.cn'; //云库服务器
  static const Path = '/chessdb.php'; //API 路径

  static Future<String> query(String board) async {


    Uri url = Uri(
      scheme: 'http',
      host: Host,
      path: Path,
      queryParameters: {
        'action': 'queryall',
        'board': board
      }
    );

    final httpClient = HttpClient();

    try {
      final request = await httpClient.getUrl(url);
      final response = await request.close();
      return await response.transform(utf8.decoder).join();

    } catch(e) {
      print("Error: $e");
    } finally {
      httpClient.close();
    }

    return null;
  }

  //请求云库在后台计算指定局面的最佳着法
  static Future<String> requestComputeBackground(String board) async {

    Uri uri = Uri(
      scheme: 'http',
      host: Host,
      path: Path,
      queryParameters: {
        'action': 'queryall',
        'board' : board,
      }
    );

    final httpClient = HttpClient();

    try {
      final request = await httpClient.getUrl(uri);
      final response = await request.close();
      return await response.transform(utf8.decoder).join();

    } catch(e) {
      print("Error: $e");
    } finally {
      httpClient.close();
    }

    return null;
  }
}



abstract class AiEngine {

  Future<void> startup() async {}

  Future<void> shutdown() async {}

  //搜索最佳着法
  Future<EngineResponse> search(Phase phase, {bool byUser = true});
}

