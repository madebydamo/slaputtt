import 'package:uttt/src/controller/GameStateController.dart';

class GameState extends Grid {
  GameState() : super(GameStateController.newGame());

  @override
  String toString() {
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
      s += (tiles.elementAt(subrow * 3 + subcolumn) as BigTile)
          .tiles
          .elementAt(subsubrow * 3 + subsubcolumn)
          .state
          .toString();
    }
    return s;
  }
}

class Tile {
  State state;

  Tile() {
    state = State.none;
  }
}

class BigTile extends Grid implements Tile {
  @override
  State state;

  BigTile(List<Tile> tiles) : super(tiles) {
    state = State.none;
  }
}

class Grid {
  List<Tile> tiles;

  Grid(List<Tile> this.tiles);
}

class State {
  static State none = new State(".");
  static State p1 = new State("X");
  static State p2 = new State("O");

  String _s;

  State(String this._s);

  @override
  String toString() {
    return _s;
  }
}
