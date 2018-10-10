class GameState extends Grid<BigTile> {
  Move lastMove;

  GameState()
      : super([
          BigTile(), //1
          BigTile(), //2
          BigTile(), //3
          BigTile(), //4
          BigTile(), //5
          BigTile(), //6
          BigTile(), //7
          BigTile(), //8
          BigTile(), //9
        ]) {
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

class BigTile extends Grid<Tile> implements Tile {
  @override
  State state;

  BigTile.withTiles(List<Tile> tiles) : super(tiles) {
    state = State.none;
  }

  BigTile()
      : super([
          Tile(), //1
          Tile(), //2
          Tile(), //3
          Tile(), //4
          Tile(), //5
          Tile(), //6
          Tile(), //7
          Tile(), //8
          Tile(), //9
        ]);
}

abstract class Grid<T extends Tile> {
  List<T> tiles;

  Grid(this.tiles);
}

class State {
  static final State none = State(".");
  static final State p1 = State("X");
  static final State p2 = State("O");

  String _s;

  State(String this._s);

  @override
  String toString() {
    return _s;
  }
}
