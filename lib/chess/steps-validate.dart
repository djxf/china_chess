

import 'package:china_chess/Common/math-ext.dart';
import 'package:china_chess/chess/cc_base.dart';
import 'package:china_chess/chess/phase.dart';

/**
 *
 * 合法性验证
 *
 *
 */

class StepValidate {

  static bool validate(Phase phase, Move move) {

    if (Side.of(phase.pieceAt(move.to)) == phase.side) return false;

    final piece = phase.pieceAt(move.from);
    var valid = false;

    if (piece == Piece.RedKing || piece == Piece.BlackKing) {
      valid = validateKingStep(phase, move);
    } else if (piece == Piece.RedAdvisor || piece == Piece.BlackAdvisor) {
      //士
      valid = validateAdvisorStep(phase, move);
    } else if (piece == Piece.RedBishop || piece == Piece.BlackBishop) {
      //相
      valid = validateBishopStep(phase, move);
    } else if (piece == Piece.RedKnigt || piece == Piece.BlackKnigt) {
      //马
      valid = validateKnightStep(phase, move);
    } else if (piece == Piece.RedRook || piece == Piece.BlackRook) {
      //车
      valid = validateRookStep(phase, move);
    } else if (piece == Piece.RedCanon || piece == Piece.BlackCanon) {
      //炮
      valid = validateCannonStep(phase, move);
    } else if (piece == Piece.RedPawn || piece == Piece.BlackPawn) {
      //兵
      valid = validatePawnStep(phase, move);
    } else {
      valid = true;
    }

    if (!valid) return false;
    return valid;
  }

  //将军
  static bool validateKingStep(Phase phase, Move move) {

    final adx = abs(move.tx - move.fx), ady = abs(move.ty - move.fy);

    final isUpDownMove = (adx == 0 && ady == 1);
    final isLeftRightMove = (adx == 1 && ady == 0);

    if (!isUpDownMove && !isLeftRightMove) return false;

    final redRange = [66, 67, 68, 75, 76, 78, 84, 85, 86];
    final blackRange = [3, 4, 5, 12, 13, 14, 21, 22, 23];
    final range = (phase.side == Side.Red) ? redRange : blackRange;

    return binarySearch(range, 0, range.length - 1, move.to) >= 0;
  }

  //士
  static bool validateAdvisorStep(Phase phase, Move move) {

    final adx = abs(move.tx - move.fx), ady = abs(move.ty - move.fy);
    if (adx != 1 || ady != 1) return false;

    final redRange = [66, 68, 76, 84, 84];
    final blackRange = [3, 5, 13, 21, 23];
    final range = (phase.side == Side.Red) ? redRange : blackRange;

    return binarySearch(range, 0, range.length - 1, move.to) >= 0;
  }

  //相
  static bool validateBishopStep(Phase phase, Move move) {
    final adx = abs(move.tx - move.fx), ady = abs(move.ty - move.fy);
    if (adx != 2 || ady != 2) return false;
    final redRange = [47, 51, 63, 67,71,83, 87];
    final blackRange = [2, 6, 18, 22, 26, 38, 42];
    final range = (phase.side == Side.Red) ? redRange : blackRange;

    if (binarySearch(range, 0, range.length - 1, move.to) < 0) return false;

    //计算卡象眼情况
    var argX = (move.tx + move.fx) ~/ 2;
    var argY = (move.ty + move.fy) ~/ 2;
    final index = argY * 9 + argX;

    if (phase.pieceAt(index) != Piece.Empty) return false;

    return true;
  }

  //马
  static bool validateKnightStep(Phase phase, Move move) {
    final adx = abs(move.tx - move.fx), ady = abs(move.ty - move.fy);
    if (!(adx == 1 && ady == 2) && !(adx == 2 && ady == 1)) return false;

    //卡马腿
    var xPos = -1;
    if (ady == 2) {
      xPos = (move.fy + (move.ty - move.fy) ~/ 2) * 9 + move.fx;
    } else if (adx == 2) {
      xPos = move.fy * 9 + (move.tx - move.fx) ~/2 + move.fx;
    }
    if (xPos != -1 && phase.pieceAt(xPos) != Piece.Empty) return false;

    return true;
  }

  //车
  static bool validateRookStep(Phase phase, Move move) {
    final adx = abs(move.tx - move.fx), ady = abs(move.ty - move.fy);
    if (adx != 0 && ady != 0) return false;

    //判断to，from之间有无棋子阻挡
    if (ady == 0) {
      if (adx < 0) {
        for (int i = move.fx - 1; i > move.tx; i--) {
          if (phase.pieceAt(move.fy * 9 + i) != Piece.Empty) return false;
        }
      } else {
        for (int i = move.fx + 1; i < move.tx; i++) {
          if (phase.pieceAt(move.fy * 9 + i) != Piece.Empty) return false;
        }
      }
    } else {
      if (ady < 0) {
        for (int i = move.fy - 1; i > move.ty; i--) {
          if (phase.pieceAt(i * 9 + move.fx) != Piece.Empty) return false;
        }
      } else {
        for (int i = move.fy + 1; i < move.ty; i++) {
          if (phase.pieceAt(i * 9 + move.fx) != Piece.Empty) return false;
        }
      }
    }

    return true;
  }

  //炮
  static bool validateCannonStep(Phase phase, Move move) {

  }

  //兵
  static bool validatePawnStep(Phase phase, Move move) {

  }


}