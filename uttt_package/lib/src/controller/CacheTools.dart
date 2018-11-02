
import 'package:uttt_package/src/model/GameState.dart';

/// Creates all possible Grids
List<Grid> getAllGrids() {
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
class Searcher {
  static final Searcher h1 = new Searcher._(1, 2, 3); //Horizontal First Row
  static final Searcher h2 = new Searcher._(4, 5, 6); //Horizontal Second Row
  static final Searcher h3 = new Searcher._(7, 8, 9); //Horizontal Third Row
  static final Searcher v1 = new Searcher._(1, 4, 7); //Vertical First Row
  static final Searcher v2 = new Searcher._(2, 5, 8); //Vertical Second Row
  static final Searcher v3 = new Searcher._(3, 6, 9); //Vertical Third Row
  static final Searcher c1 = new Searcher._(1, 5, 9); //Cross First
  static final Searcher c2 = new Searcher._(3, 5, 7); //Cross Second
  static final List<Searcher> all = [
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

  /// Initialises a
  Searcher._(int first, int second, int third)
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
