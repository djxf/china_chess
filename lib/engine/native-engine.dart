


import 'dart:io';

import 'package:china_chess/chess/cc_base.dart';
import 'package:china_chess/chess/phase.dart';
import 'package:china_chess/engine/clound-engine.dart';
import 'package:china_chess/engine/engine.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

class NativeEngine extends AiEngine {

  static const platform = const MethodChannel("cn.apppk.chessroad/engine");

  @override
  Future<EngineResponse> search(Phase phase, {bool byUser = true}) async {
      if (await isThink()) await stopSearching();

      //发送局面信息给引擎
      send(buildPositionCommand(phase));
      send('go time 5000');

      //等待回复
      final String response = await waitResponse(['bestmove', 'nobestmove']);

      if (response.startsWith('bestmove')) {
        var step = response.substring('bestmove'.length + 1);

        final pos = step.indexOf(' ');
        if (pos > -1) {
          step = step.substring(0, pos);
        }

        return EngineResponse('move', value: Move.fromEngineStep(step));
      }

      if (response.startsWith('nobestmove')) {
        return EngineResponse('nobestmove');
      }

      return EngineResponse('timeout');
  }

  @override
  Future<void> startup() async{


    await waitResponse(['ucciok'], sleep: 1, times: 30);
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

    final docDir = p.current;
    print("docDir: $docDir");
    final bookFile = File('${docDir}/BOOK.DAT');

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

  //
  String buildPositionCommand(Phase phase) {

    final startPhase = phase.lastCapturedPhase;
    final move = phase.movesSinceLastCaptured();

    if (move.isEmpty) return 'postion fen $startPhase';

    return 'postion fen $startPhase move $move';
  }

  Future<String> waitResponse(List<String> list, {sleep = 100, times = 100}) async{
      if (times <= 0) return '';

      final response = await read();

      if (response != null) {
        for (var prefix in list) {
          if (response.startsWith(prefix)) return response;
        }
      }

      return Future<String>.delayed(
        Duration(milliseconds: sleep),
          () => waitResponse(list, times: times -1)
      );
  }



}