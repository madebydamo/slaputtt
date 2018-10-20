import 'dart:math';

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
    lastMove = Move.init;
  }
}

class Move {
  static final Move init = Move(State.p2, 99, 99, 99, 99);

  State state;
  int xBigTile;
  int yBigTile;
  int xTile;
  int yTile;

  Move.smallMove(this.state, this.xTile, this.yTile) {
    xBigTile = 0;
    yBigTile = 0;
  }

  Move(this.state, this.xTile, this.yTile, this.xBigTile, this.yBigTile);

  Move.ofIndex(this.state, int bigIndex, int smallIndex) {
    xBigTile = bigIndex % 3;
    yBigTile = bigIndex ~/ 3;
    xTile = smallIndex % 3;
    yTile = smallIndex ~/ 3;
  }

  Move.ofIndexSmall(this.state, int smallIndex) {
    xBigTile = 0;
    yBigTile = 0;
    xTile = smallIndex % 3;
    yTile = smallIndex ~/ 3;
  }

  get bigIndex => yBigTile * 3 + xBigTile;

  get smallIndex => yTile * 3 + xTile;
}

class Tile {
  State state;

  Tile() {
    state = State.none;
  }

  Tile.fromState(State s) {
    state = s;
  }

  @override
  String toString() {
    return state.toString();
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
        ]) {
    state = State.none;
  }
}

abstract class Grid<T extends Tile> {
  List<T> tiles;

  Grid(this.tiles);

  get value => _getHashFrag(0);

  int _getHashFrag(int index) {
    if (index == 9) return 0;
    return State.valueOf(tiles[index].state) * pow(3, index) +
        _getHashFrag(index + 1);
  }
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

  static valueOf(State s) {
    if (s == none) return 0;
    if (s == p1) return 1;
    if (s == p2) return 2;
    return -1;
  }

  static State flip(State s) {
    if (s == p1) return p2;
    if (s == p2) return p1;
    return none;
  }
}
