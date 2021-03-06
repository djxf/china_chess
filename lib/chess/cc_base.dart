
class Side {


  static const Unknown = '-';
  static const Red = 'w'; //红
  static const Black = 'b'; //黑

  static String of(String piece) {
    if('RNBAKCP'.contains(piece)) return Red;
    if('rnbakcp'.contains(piece)) return Black;
    return Unknown;
  }


  static bool sameSide(String p1, String p2) {
    return of(p1) == of(p2);
  }

  static String oppo(String side) {
    if (side == Red) return Black;
    if (side == Black) return Red;
    return side;
  }
}

//棋子类
class Piece {

  static const Empty = ' ';

  static const RedRook = 'R';
  static const RedKnigt = 'N';
  static const RedBishop = 'B';
  static const RedAdvisor = 'A';
  static const RedKing = 'K';
  static const RedCanon = 'C';
  static const RedPawn = 'P';

  static const BlackRook = 'r';
  static const BlackKnigt = 'n';
  static const BlackBishop = 'b';
  static const BlackAdvisor = 'a';
  static const BlackKing = 'k';
  static const BlackCanon = 'c';
  static const BlackPawn = 'p';


  static const Map<String,String> Names = {
    Empty: ' ',
    RedRook: '车',
    RedKnigt: '马',
    RedBishop: '相',
    RedAdvisor: '仕',
    RedKing: '帅',
    RedCanon: '炮',
    RedPawn: '兵',


    BlackRook: '车',
    BlackKnigt: '马',
    BlackBishop: '相',
    BlackAdvisor: '士',
    BlackCanon: '炮',
    BlackKing: '将',
    BlackPawn: '卒'




  };

  static bool isRed(String c) => 'RNBAKCP'.contains(c);

  static bool isBlack(String c) => 'rnbackcp'.contains(c);

}

//对战结果： 未决， 赢， 输， 和
enum BattleResult { Pending, Win, Lose, Draw}

class Move {

  static const InvalidIndex = -1;

  int from, to;

  int fx, fy, tx, ty;

  String captured;

  String step;

  Move(this.from, this.to, {this.captured = Piece.Empty}) {
    fx = from % 9;
    fy = from ~/ 9;

    tx = to % 9;
    ty = to ~/9;

    if (fx < 0 || fx > 8 || fy < 0 || fy > 9) {
      throw "Error: Invlid Step (from: $from, to: $to)";
    }

    step = String.fromCharCode('a'.codeUnitAt(0) + fx) + (9 - fy).toString();
    step += String.fromCharCode('a'.codeUnitAt(0) + tx) + (9 - ty).toString();
  }

  Move.fromEngineStep(String step) {

    this.step = step;

    if (!validateEngineStep(step)) {
      throw "Error: Invlid Step: $step";
    }

    final fx = step[0].codeUnitAt(0) - 'a'.codeUnitAt(0);
    final fy = 9 - (step[1].codeUnitAt(0) - '0'.codeUnitAt(0));
    final tx = step[2].codeUnitAt(0) - 'a'.codeUnitAt(0);
    final ty = 9 - (step[3].codeUnitAt(0) - '0'.codeUnitAt(0));

    from = fx + fy * 9;
    to = tx + ty * 9;
    captured = Piece.Empty;
  }

  static bool validateEngineStep(String step) {

    if (step == null || step.length < 4)  return false;

    final fx = step[0].codeUnitAt(0) - 'a'.codeUnitAt(0);
    final fy = 9 - (step[1].codeUnitAt(0) - '0'.codeUnitAt(0));
    if (fx < 0 || fx > 8 || fy < 0 || fy > 9) return false;

    final tx = step[2].codeUnitAt(0) - 'a'.codeUnitAt(0);
    final ty = 9 - (step[3].codeUnitAt(0) - '0'.codeUnitAt(0));
    if (tx < 0 || tx > 8 || ty < 0 || ty > 9) return false;

    return true;
  }

}
