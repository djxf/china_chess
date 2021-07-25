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



class CloudEngine {

  Future<EngineResponse> search(Phase phase, {bool byUser = true}) async {

    final fen = phase.toFen();
    var resonpse = await ChessDB.query(fen);

    if (resonpse == null) return EngineResponse("network-error");

    if (!resonpse.startsWith("move:")) {
      print("ChessDB.query: $resonpse\n");
    } else {

      //有着法列表返回时
      final firstStep = resonpse.split('|')[0];
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
          resonpse = await ChessDB.requestComputeBackground(fen);
          print("ChessDB.requestComputeBackground: $resonpse\n");
        }

        return Future<EngineResponse>.delayed(
          Duration(seconds: 2),
            () => search(phase, byUser: false),
        );

      }


    }

    return EngineResponse("unknown-error");
  }
}