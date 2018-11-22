import 'package:uttt_package/src/controller/CacheTools.dart';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/controller/GridCache.dart' as GridCache;

Map<int, Map<State, _HeuristicInfo>> cache = _getCache();

Map<int, Map<State, _HeuristicInfo>> initCache() {
  return cache;
}

Map<int, Map<State, _HeuristicInfo>> _getCache() {
  Map<int, Map<State, _HeuristicInfo>> map = Map();
  getAllGrids().forEach((grid) {
    Map<State, _HeuristicInfo> stateMap = Map();
    if (!GridCache.cache[grid.value].isFinished) {
      _HeuristicInfo infop1 = _HeuristicInfo(0, 0, 0);
      Searcher.all.forEach((s) {
        int p1 = s.getP1(grid);
        if (p1 > 0 && s.getP2(grid) == 0) {
          switch (p1) {
            case 1:
              infop1.one = infop1.one + 1;
              break;
            case 2:
              infop1.two = infop1.two + 1;
              break;
            case 3:
              infop1.three = infop1.three + 1;
              break;
            default:
              throw new Exception("More than three is not allowed");
          }
        }
      });
      stateMap.putIfAbsent(State.p1, () => infop1);
      _HeuristicInfo infop2 = _HeuristicInfo(0, 0, 0);
      Searcher.all.forEach((s) {
        int p2 = s.getP2(grid);
        if (p2 > 0 && s.getP1(grid) == 0) {
          switch (p2) {
            case 1:
              infop2.one = infop2.one + 1;
              break;
            case 2:
              infop2.two = infop2.two + 1;
              break;
            case 3:
              infop2.three = infop2.three + 1;
              break;
            default:
              throw new Exception("More than three is not allowed");
          }
        }
      });
      stateMap.putIfAbsent(State.p2, () => infop2);
    } else {
      if (GridCache.cache[grid.value].winner == State.p1) {
        stateMap = {
          State.p1: _HeuristicInfo(0, 0, 1),
          State.p2: _HeuristicInfo(0, 0, 0)
        };
      } else if (GridCache.cache[grid.value].winner == State.p2) {
        stateMap = {
          State.p1: _HeuristicInfo(0, 0, 0),
          State.p2: _HeuristicInfo(0, 0, 1)
        };
      } else {
        stateMap = {
          State.p1: _HeuristicInfo(0, 0, 0),
          State.p2: _HeuristicInfo(0, 0, 0)
        };
      }
    }
    map.putIfAbsent(grid.value, () => stateMap);
  });
  return map;
}

class _HeuristicInfo {
  int one;
  int two;
  int three;

  _HeuristicInfo(this.one, this.two, this.three);
}
