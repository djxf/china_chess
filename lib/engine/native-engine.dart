


import 'dart:io';

import 'package:china_chess/chess/phase.dart';
import 'package:china_chess/engine/clound-engine.dart';
import 'package:china_chess/engine/engine.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class NativeEngine extends AiEngine {

  static const platform = const MethodChannel("cn.apppk.chessroad/engine");

  @override
  Future<EngineResponse> search(Phase phase, {bool byUser = true}) {

  }

  @override
  Future<void> startup() {
    return super.startup();
  }

  @override
  Future<void> shutdown() {
    return super.shutdown();
  }

  //向引擎发送指令
  Future<void> send(String command) async {
    try {
      await platform.invokeMethod('send', command);
    } catch(e) {
      print("Native sendCommand Error: $e");
    }
  }

  //读取引擎的响应信息
  Future<String> read() async {
    try {
      await platform.invokeMethod('read');
    } catch(e) {
      print("Native sendCommand Error: $e");
    }
  }

  //查询引擎状态是否就绪
  Future<bool> isReady() async {
    try {
      await platform.invokeMethod('isReady');
    } catch(e) {
      print("Native sendCommand Error: $e");
    }

    return null;
  }

  //查询引擎状态是否在思考中
  Future<bool> isThink() async {
    try {
      await platform.invokeMethod('isReady');
    } catch(e) {
      print("Native sendCommand Error: $e");
    }

    return null;
  }

  //给引擎设置开局库
  Future setBookFile() async {

    final docDir = await getApplicationDocumentsDirectory();
    print("docDir: $docDir");
    final bookFile = File('${docDir.path}/BOOK.DAT');

    try {
        if (!await bookFile.exists()) {
          await bookFile.create(recursive: true);
          final bytes = await rootBundle.load("assets/BOOK.DAT");
          await bookFile.writeAsBytes(bytes.buffer.asUint8List());
        }
    } catch(e) {
      print(e);
    }

    await send("setoption bookfiles ${bookFile.path}");
  }

  //停止正在进行的搜索
  Future<void> stopSearching() async {
    await send('stop');
  }


}