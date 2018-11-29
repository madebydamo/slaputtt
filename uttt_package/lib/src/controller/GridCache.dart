import 'package:uttt_package/src/controller/CacheTools.dart';
import 'package:uttt_package/src/model/GameState.dart';

/// A cache with [_GridInfo] of all possible Grids
Map<int, _GridInfo> cache = _getCache();

class _GridInfo {
  final bool _isFinished;
  final List<Move> _moves;
  final State _winner;

  _GridInfo(this._isFinished, this._moves, this._winner);

  get isFinished => _isFinished;

  get moves => _moves;

  get winner => _winner;
}

/// ONLY FOR GENERATING CACHE
/// Creates a cache with [_GridInfo] of all possible Grids
Map<int, _GridInfo> _getCache() {
  Map<int, _GridInfo> cache = Map();
  getAllGrids().forEach((g) {
    bool isFinished = false;
    bool remi = true;
    bool p1Finished = false;
    bool p2Finished = false;
    State winner = State.none;
    Searcher.all.forEach((s) {
      int p1 = s.getP1(g);
      int p2 = s.getP2(g);
      p1Finished = p1Finished || p1 == 3;
      p2Finished = p2Finished || p2 == 3;
      isFinished = isFinished || p1Finished || p2Finished;
      remi = remi && p1 != 0 && p2 != 0;
    });
    isFinished = isFinished || remi;
    if (isFinished && p1Finished && !p2Finished) {
      winner = State.p1;
    }
    if (isFinished && !p1Finished && p2Finished) {
      winner = State.p2;
    }
    List<Move> moves = [];
    if (!isFinished) {
      for (int i = 0; i < 9; i++) {
        if (g.tiles[i].state == State.none) {
          moves.add(Move.ofIndexSmall(State.none, i));
        }
      }
    }
    moves.sort((a, b) {
      return getMoveValue(a).compareTo(getMoveValue(b));
    });
    cache.putIfAbsent(g.value, () => _GridInfo(isFinished, moves, winner));
  });
  return cache;
}
