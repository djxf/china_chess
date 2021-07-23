
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