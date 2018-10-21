import 'package:uttt/src/model/GameState.dart';

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

//ONLY FOR GENERATING CACHE FILE
Map<int, _GridInfo> _getCache() {
  Map<int, _GridInfo> cache = Map();
  _getAllGrids().forEach((g) {
    bool isFinished = false;
    bool remi = true;
    bool p1Finished = false;
    bool p2Finished = false;
    State winner = State.none;
    _Searcher.all.forEach((s) {
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
        BigTile.withTiles(List.from(states.map((s) => Tile.fromState(s))));
    grids.add(grid);
    states = _nextState(states, 0);
  }
  return grids;
}

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

class _Searcher {
  static final _Searcher h1 = new _Searcher(1, 2, 3); //Horizontal First Row
  static final _Searcher h2 = new _Searcher(4, 5, 6); //Horizontal Second Row
  static final _Searcher h3 = new _Searcher(7, 8, 9); //Horizontal Third Row
  static final _Searcher v1 = new _Searcher(1, 4, 7); //Vertical First Row
  static final _Searcher v2 = new _Searcher(2, 5, 8); //Vertical Second Row
  static final _Searcher v3 = new _Searcher(3, 6, 9); //Vertical Third Row
  static final _Searcher c1 = new _Searcher(1, 5, 9); //Cross First
  static final _Searcher c2 = new _Searcher(3, 5, 7); //Cross Second
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

  _Searcher(int first, int second, int third)
      : _points = [first - 1, second - 1, third - 1];

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
