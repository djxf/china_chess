


import 'package:china_chess/chess/cc_base.dart';
import 'package:china_chess/chess/phase.dart';

/**
 * 管理对局事务类
 * 单例
 *
 *
 */

class Battle {
    static Battle _instance;

    //选中的位置， 选中的棋子要去的位置。
    int _focusIndex, _blurIndex;


    static get shared {
      _instance ??= Battle();
      return _instance;
    }


    Phase _phase;


    //初始化
    init() {
      _phase = Phase.defaultPhase();
      _blurIndex = _focusIndex = -1;
    }


    //移动棋子
    bool move(int from, int to) {

      if (!_phase.move(from, to)) return false;

      _blurIndex = from; // 来自
      _focusIndex = -1;  // 到哪里去
      return true;
    }

    //选中一个棋子时，使用_focusIndex来标记此位置
    //绘制时，将在这个位置绘制选中的效果
    select(int pos) {
      _focusIndex = pos;
      _blurIndex = -1;
    }

    clear() {
      _blurIndex = _focusIndex = -1;
    }

    get focusIndex => _focusIndex;

    get phase => _phase;

    get blurIndex => _blurIndex;

    //扫描对局结果
    BattleResult scanBattleResult() {
      //TODO
      return BattleResult.Pending;
    }
}