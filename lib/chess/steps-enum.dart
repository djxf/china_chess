


//枚举当前局面下所有符合象棋规则的着法
import 'package:china_chess/Common/math-ext.dart';
import 'package:china_chess/chess/cc_base.dart';
import 'package:china_chess/chess/phase.dart';
import 'package:flutter/material.dart';

class StepsEnumerator {

  static List<Move> enumSteps(Phase phase) {

    final steps = <Move>[];

    for(var row = 0; row < 10; row++) {
      for(var col = 0; col < 9; col++) {

        final from = row * 9 +col;
        final piece = phase.pieceAt(from);

        if (Side.of(piece) != phase.side) continue;

        var pieceSteps;
        if (piece == Piece.RedKing || pieceSteps == Piece.BlackKing) {
            pieceSteps = enumKingSteps(phase, row, col, from);
        } else if (piece == Piece.BlackRook || pieceSteps == Piece.RedRook) {
            pieceSteps = enumRookSteps(phase, row, col, from);
        } else if (piece == Piece.BlackKnigt || pieceSteps == Piece.RedKnigt) {
          pieceSteps = enumKnightSteps(phase, row, col, from);
        } else if (piece == Piece.BlackBishop || pieceSteps == Piece.RedBishop) {
          pieceSteps = enumBishopSteps(phase, row, col, from);
        } else if (piece == Piece.BlackAdvisor || pieceSteps == Piece.RedAdvisor) {
          pieceSteps = enumAdvisorSteps(phase, row, col, from);
        } else if (piece == Piece.RedCanon || pieceSteps == Piece.BlackCanon) {
          pieceSteps = enumCanonSteps(phase, row, col, from);
        } else if (piece == Piece.BlackPawn || pieceSteps == Piece.RedPawn) {
          pieceSteps = enumPawnSteps(phase, row, col, from);
        }
        steps.addAll(pieceSteps);
      }
    }
    return steps;
  }

  static posOnBoard(int pos) => pos > -1 && pos < 90;


  static List<Move> enumKingSteps(Phase phase, int row, int col, int from) {

    final offsetList = [
      [-1, 0],
      [0, -1],
      [1, 0],
      [0, 1]
    ];

    final redRange = [66, 67, 68, 75, 76, 77, 84, 85, 85];
    final blackRange = [3, 4, 5, 12, 13, 14, 21, 22, 23];
    final range = (phase.side == Side.Red ? redRange : blackRange);
    final steps = <Move>[];
    for (var i = 0; i < 4; i++) {

      final offset = offsetList[i];
      final to = (row + offset[0]) * 9 + col + offset[1];

      if (!posOnBoard(to) || Side.of(phase.pieceAt(to)) == phase.side) {
        continue;
      }

      if (binarySearch(range, 0, range.length - 1, to) > -1) {
        steps.add(Move(from, to));
      }
      return steps;
    }
  }

  //车的枚举
  static List<Move> enumRookSteps(Phase phase, int row, int col, int from) {
    final steps = <Move>[];

    //to left
    for (var c = col - 1; c >= 0; c--) {
      final to = row * 9 + c;
      final target = phase.pieceAt(to);

      if (target == Piece.Empty) {
        steps.add(Move(from, to));
      } else {
        if (Side.of(target) != phase.side) {
          steps.add(Move(from, to));
        }
        break; //表示车遇到了阻挡
      }
    }

    //to top
    for (var r = row - 1; r >= 0; r--) {
      final to = r * 9 + col;
      final target = phase.pieceAt(to);

      if (target == Piece.Empty) {
        steps.add(Move(from, to));
      } else {
        if (Side.of(target) != phase.side) {
          steps.add(Move(from, to));
        }
        break; //表示车遇到了阻挡
      }
    }

    //to right
    for (var c = col + 1; c < 9; c++) {
      final to = row * 9 + c;
      final target = phase.pieceAt(to);
      if (target == Piece.Empty) {
        steps.add(Move(from, to));
      } else {
        if (Side.of(target) != phase.side) {
          steps.add(Move(from, to));
        }
        break; //表示车遇到了阻挡
      }
    }

    //to down
    for (var r = row + 1; r < 10; r++) {
      final to = r * 9 + col;
      final target = phase.pieceAt(to);
      if (target == Piece.Empty) {
        steps.add(Move(from, to));
      } else {
        if (Side.of(target) != phase.side) {
          steps.add(Move(from, to));
        }
        break; //表示车遇到了阻挡
      }
    }

    return steps;
  }

  //炮的枚举
  static List<Move> enumCanonSteps(Phase phase, int row, int col, int from) {

    final steps = <Move>[];

    //to lfet
    var overPiece = false;

    for (var c = col -1; c >= 0; c--) {
      final to = row * 9 + c;
      final target = phase.pieceAt(to);

      if (!overPiece) {
        if (target == Piece.Empty) {
          steps.add(Move(from, to));
        } else {
          overPiece = true;
        }
      } else {
        if (target != Piece.Empty) {
          if (Side.of(target) != phase.side) {
            steps.add(Move(from, to));
          }
          break;
        }
      }
    }

    //to top
    overPiece = false;
    for (var r = row - 1; r >= 0; r--) {

      final to = r * 9 + col;
      final target = phase.pieceAt(to);

      if (!overPiece) {
        if (target == Piece.Empty) {
          steps.add(Move(from, to));
        } else {
          overPiece = true;
        }
      } else {
        if (target != Piece.Empty) {
          if (Side.of(target) != phase.side) {
            steps.add(Move(from, to));
          }
          break;
        }
      }
    }

    //to right
    overPiece = false;
    for (var c = col + 1; c < 9; c++) {
      final to = row * 9 + col;
      final target = phase.pieceAt(to);

      if (!overPiece) {
        if (target == Piece.Empty) {
          steps.add(Move(from, to));
        } else {
          overPiece = true;
        }
      } else {
        if (target != Piece.Empty) {
          if (Side.of(target) != phase.side) {
            steps.add(Move(from, to));
          }
          break;
        }
      }
    }

    //to down
    overPiece = false;
    for (var r = row + 1; r < 10; r++) {
      final to =  r * 9 + col;
      final target = phase.pieceAt(to);

      if (!overPiece) {
        if (target == Piece.Empty) {
          steps.add(Move(from, to));
        } else {
          overPiece = true;
        }
      } else {
        if (target != Piece.Empty) {
          if (Side.of(target) != phase.side) {
            steps.add(Move(from, to));
          }
          break;
        }
      }
    }
    return steps;
  }

  //士的着法枚举
  static List<Move> enumAdvisorSteps(Phase phase, int row, int col, int from) {

    final offsetList = [
      [-1, -1],
      [1, -1],
      [-1, 1],
      [1, 1]
    ];

    final redRange = [66, 68, 76, 84, 86];
    final blackRange = [3, 5, 13, 21, 23];
    final range = phase.side == Side.Red ? redRange : blackRange;

    final steps = <Move>[];

    for (var i = 0; i < 4; i++) {

      final offset = offsetList[i];
      final to = (row + offset[0]) * 9 + col + offset[1];

      if (!posOnBoard(to) || Side.of(phase.pieceAt(to)) == phase.side) {
        continue;
      }

      if (binarySearch(range, 0, range.length - 1, to) > -1) {
        steps.add(Move(from, to));
      }
    }
    return steps;
  }

  //象的着法枚举
  static List<Move> enumBishopSteps(Phase phase, int row, int col, int from) {

    final heartOffsetList = [
      [-1, -1],
      [1, -1],
      [-1, 1],
      [1, 1]
    ];

    final offsetList = [
      [-2, -2],
      [2, -2],
      [-2, 2],
      [2, 2]
    ];

    final redRange = [46, 51, 63, 67, 71, 83, 87];
    final blackRange = [2, 6, 18, 22, 26, 38, 42];
    final range = phase.side == Side.Red ? redRange : blackRange;

    final steps = <Move>[];

    for (var i = 0; i < 4; i++) {

      final heartOffset = heartOffsetList[i];
      final heart = (row + heartOffset[0]) * 9 + (col + heartOffset[1]);

      if(!posOnBoard(heart) || phase.pieceAt(heart) != Piece.Empty) {
        continue;
      }

      final offset = offsetList[i];
      final to = (row + offset[0]) * 9 + col + offset[1];

      if (!posOnBoard(to) || Side.of(phase.pieceAt(to)) == phase.side) {
        continue;
      }

      if (binarySearch(range, 0, range.length - 1, to) > -1) {
        steps.add(Move(from, to));
      }
    }
    return steps;
  }

  //马
  static List<Move> enumKnightSteps(Phase phase, int row, int col, int from) {

    final offsetList = [
      [-2, -1],
      [-1, -2],
      [1, -2],
      [2, -1],
      [2, 1],
      [1, 2],
      [-1, 2],
      [-2, 1]
    ];

    final footOffsetList = [
      [-1, 0],
      [0, -1],
      [0, -1],
      [1, 0],
      [1, 0],
      [0, 1],
      [0, 1],
      [-1, 0]
    ];

    final steps = <Move>[];

    for(var i = 0; i < 8; i++) {

      final offset = offsetList[i];
      final nr = row + offset[0], nc = col + offset[1];

      if (nr < 0 || nr > 9 || nc < 0 || nc > 9) continue;

      final to = nr * 9 + nc;
      if (!posOnBoard(to) || Side.of(phase.pieceAt(to)) == phase.side) {
        continue;
      }

      final footOffset = footOffsetList[i];
      final fr = row + footOffset[0], fc = col + footOffset[1];
      final foot = fr * 9 + fc;

      if (!posOnBoard(to) || phase.pieceAt(to) != Piece.Empty) {
        continue;
      }

      steps.add(Move(from, to));
    }
    return steps;
  }

  //兵
  static List<Move> enumPawnSteps(Phase phase, int row, int col, int from) {

    final steps = <Move>[];
    var to = (row + (phase.side == Side.Red ? -1: 1)) * 9 + col;

    if (posOnBoard(to) && Side.of(phase.pieceAt(to)) != phase.side) {
      steps.add(Move(from, to));
    }

    if ((phase.side == Side.Red && row < 5) || (phase.side == Side.Black)) {
      if (col > 0) {
        to = row * 9 + col - 1;
        if (posOnBoard(to) && Side.of(phase.pieceAt(to)) != phase.side) {
          steps.add(Move(from, to));
        }
      }

      if (col < 8) {
        to = row * 9 + col + 1;
        if (posOnBoard(to) && Side.of(phase.pieceAt(to)) != phase.side) {
          steps.add(Move(from, to));
        }
      }
    }
    return steps;
  }




}