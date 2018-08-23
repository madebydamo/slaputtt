import 'package:uttt/src/controller/GameStateController.dart';

class GameState extends Grid {
  Move lastMove;
  GameState() : super(GameStateController.newGame()) {
    lastMove = null;
  }
}

class Move {
  State state;
  int xBigTile;
  int yBigTile;
  int xTile;
  int yTile;

  Move(this.state, this.xTile, this.yTile) {
    xBigTile = 0;
    yBigTile = 0;
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
