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

/// ONLY FOR GENERATING CACHE FILE
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
    cache.putIfAbsent(g.value, () => _GridInfo(isFinished, moves, winner));
  });
  return cache;
}
<<<<<<< HEAD
=======

/// Creates all possible Grids
List<Grid> _getAllGrids() {
  List<State> states = [
    State.none,
    State.none,
    State.none,
    State.none,
    State.none,
    State.none,
    State.none,
    State.none,
    State.none,
    State.none,
  ];
  List<Grid> grids = List();
  while (states[9] == State.none) {
    Grid grid =
    BigTile.withTiles(
        List.from(states.sublist(0, 9).map((s) => Tile.fromState(s))));
    grids.add(grid);
    states = _nextState(states, 0);
  }
  return grids;
}

/// Used to create the next possible grid.
List<State> _nextState(List<State> states, int index) {
  if (states[index] == State.none) {
    states[index] = State.p1;
  } else if (states[index] == State.p1) {
    states[index] = State.p2;
  } else if (states[index] == State.p2) {
    states[index] = State.none;
    states = _nextState(states, index + 1);
  }
  return states;
}

/// Helper class to evaluate a grid and all his rows.
class _Searcher {
  static final _Searcher h1 = new _Searcher._(1, 2, 3); //Horizontal First Row
  static final _Searcher h2 = new _Searcher._(4, 5, 6); //Horizontal Second Row
  static final _Searcher h3 = new _Searcher._(7, 8, 9); //Horizontal Third Row
  static final _Searcher v1 = new _Searcher._(1, 4, 7); //Vertical First Row
  static final _Searcher v2 = new _Searcher._(2, 5, 8); //Vertical Second Row
  static final _Searcher v3 = new _Searcher._(3, 6, 9); //Vertical Third Row
  static final _Searcher c1 = new _Searcher._(1, 5, 9); //Cross First
  static final _Searcher c2 = new _Searcher._(3, 5, 7); //Cross Second
  static final List<_Searcher> all = [
    h1,
    h2,
    h3,
    v1,
    v2,
    v3,
    c1,
    c2,
  ];

  final List<int> _points;

  /// Initialises a  Searcher
  _Searcher._(int first, int second, int third)
      : _points = [first - 1, second - 1, third - 1];

  /// Returns the number of fields from [Player] 1
  int getP1(Grid grid) {
    int counter = 0;
    State s = State.p1;
    _points.forEach((i) {
      if (grid.tiles[i].state == s) {
        counter++;
      }
    });
    return counter;
  }

  /// Returns the number of fields from [Player] 2
  int getP2(Grid grid) {
    int counter = 0;
    State s = State.p2;
    _points.forEach((i) {
      if (grid.tiles[i].state == s) {
        counter++;
      }
    });
    return counter;
  }

  /// Returns the number of fields, which were n
  int getNone(Grid grid) {
    int counter = 0;
    State s = State.none;
    _points.forEach((i) {
      if (grid.tiles[i].state == s) {
        counter++;
      }
    });
    return counter;
  }
}
>>>>>>> master
