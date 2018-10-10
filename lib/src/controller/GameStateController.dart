import 'package:uttt/src/model/GameState.dart';

void visualize(GameState state) {
  String s = "";
  for (int i = 0; i < 132; i++) {
    int row = i ~/ 12;
    int column = i % 12;
    if (column == 11) {
      s += "\n";
      continue;
    }
    if ((column + 1) % 4 == 0) {
      s += " ";
      continue;
    }
    if ((row + 1) % 4 == 0) {
      s += " ";
      continue;
    }
    int subrow = (row - row ~/ 4) ~/ 3;
    int subcolumn = (column - column ~/ 4) ~/ 3;
    int subsubrow = (row - row ~/ 4) % 3;
    int subsubcolumn = (column - column ~/ 4) % 3;
    //print((subrow * 3 + subcolumn).toString() + ":" + (subsubrow * 3 + subsubcolumn).toString());
    s += state.tiles.elementAt(subrow * 3 + subcolumn)
        .tiles
        .elementAt(subsubrow * 3 + subsubcolumn)
        .state
        .toString();
  }
  print(s);
}

bool isGameFinished(GameState state) {
  //TODO implement
  return false;
}

double evaluateValue(GameState state) {
  //TODO implement
  //TODO Extraclass with Organism
  return 0.0;
}

List<Move> getAllPossibleMoves(GameState state) {
  //TODO implement
  return new List<Move>();
}

GameState playMove(GameState state, Move move) {
  //TODO implement
  return new GameState();
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

  int getP1(Grid tile) {
    int counter = 0;
    State s = State.p1;
    _points.forEach((i) {
      if (tile.tiles[i].state == s) {
        counter++;
      }
    });
    return counter;
  }

  int getP2(Grid tile) {
    int counter = 0;
    State s = State.p2;
    _points.forEach((i) {
      if (tile.tiles[i].state == s) {
        counter++;
      }
    });
    return counter;
  }

  int getNone(Grid tile) {
    int counter = 0;
    State s = State.none;
    _points.forEach((i) {
      if (tile.tiles[i].state == s) {
        counter++;
      }
    });
    return counter;
  }
}

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
main() {}
