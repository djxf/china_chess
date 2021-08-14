import 'package:china_chess/chess/cc_base.dart';
import 'package:china_chess/chess/phase.dart';
import 'package:china_chess/engine/engine.dart';

/**
 * 引擎封装
 *
 *
 */

class EngineResponse {

  final String type;
  final dynamic value;

  EngineResponse(this.type, {this.value});
}



class CloudEngine extends AiEngine{

  Future<EngineResponse> search(Phase phase, {bool byUser = true}) async {

    final fen = phase.toFen();
    var response = await ChessDB.query(fen);

    if (response == null) return EngineResponse("network-error");

    if (!response.startsWith("move:")) {
      print("ChessDB.query: $response\n");

      if (byUser) {
        response = await ChessDB.requestComputeBackground(fen);
        print("ChessDB.requestComputeBackground: $response\n");
      }

      return EngineResponse(
          'move',
          value: Move.fromEngineStep(response.substring(5,8))
      );
    } else {

      //有着法列表返回时
      final firstStep = response.split('|')[0];
      print("ChessDB.query: $firstStep");
      final segments = firstStep.split(',');
      if (segments.length < 2) return EngineResponse("data-error");
      final move = segments[0], score = segments[1];

      final scoreSegments = score.split(':');
      if (scoreSegments.length < 2) return EngineResponse('data-error');

      final moveWithScore = int.tryParse(scoreSegments[1]) != null;
      //存在有效着法
      if (moveWithScore) {
        //
        final step = move.substring(5);

        if(Move.validateEngineStep(step)) {
          return EngineResponse(
            'move',
              value: Move.fromEngineStep(step)
          );
        }
      } else {

        //云库没有遇到这个局面，请求它执行后台计算
        if (byUser) {
          response = await ChessDB.requestComputeBackground(fen);
          print("ChessDB.requestComputeBackground: $response\n");
        }

        return Future<EngineResponse>.delayed(
          Duration(seconds: 2),
            () => search(phase, byUser: false),
        );
      }
    }

    return EngineResponse("unknown-error");
  }


  Future<EngineResponse> mainSearch(Phase phase) async{


    final fen = phase.toFen();
    var response = await ChessDB.requestComputeBackground(fen);

    if (!response.startsWith("move:")) {
      return EngineResponse(
          'Error: $response',
      );
    }

    final move = response.substring(5, 8);
    return EngineResponse(
      'move',
      value: Move.fromEngineStep(move)
    );
  }
}