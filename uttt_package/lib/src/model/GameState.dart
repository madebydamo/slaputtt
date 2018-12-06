import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'GameState.g.dart'; //regenerate with "pub run build_runner build"

/// The Model for the big Tic Tac Toe field
@JsonSerializable()
class GameState extends Grid<BigTile> {
  /// The last played move
  Move lastMove;

  /// Initialises an empty GameState
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


  @override
  get playedMoves {
    int i = 0;
    tiles.forEach((bigTile) => i = bigTile.playedMoves);
    return i;
  }

  String toCompactString() {
    StringBuffer buffer = StringBuffer();
    tiles.forEach((bigTile) => buffer.writeAll(bigTile.tiles));
    buffer.write(lastMove);
    return buffer.toString();
  }

  factory GameState.fromJson(Map<String, dynamic> json) => _$GameStateFromJson(json);

  Map<String, dynamic> toJson() => _$GameStateToJson(this);

  @override
  bool operator ==(other) {
    bool equal = other is GameState;
    equal = equal && (other as GameState).lastMove == lastMove;
    for (int i = 0; i < 9; i++) {
      equal = equal && (other as GameState).tiles[i].value == tiles[i].value;
    }
    return equal;
  }
}

/// The Model for a Move. Provides x and y for the big grid [GameState] and the
/// sub grid [BigTile]
@JsonSerializable()
class Move {
  static final Move init = Move(State.p2, 99, 99, 99, 99);

  ///State of the player
  State state;

  /// X-coordinate of the big grid
  int xBigTile;

  /// Y-coordinate of the big grid
  int yBigTile;

  /// X-coordinate of the sub grid
  int xTile;

  /// Y-coordinate of the sub grid
  int yTile;

  /// Initialises only the move for the sub grid [BigTile]
  Move.smallMove(this.state, this.xTile, this.yTile) {
    xBigTile = 0;
    yBigTile = 0;
  }

  /// Initialises a move with all fields
  Move(this.state, this.xTile, this.yTile, this.xBigTile, this.yBigTile);

  /// Initialises a move, based on the given indexes
  Move.ofIndex(this.state, int bigIndex, int smallIndex) {
    xBigTile = bigIndex % 3;
    yBigTile = bigIndex ~/ 3;
    xTile = smallIndex % 3;
    yTile = smallIndex ~/ 3;
  }

  /// Initialises a move for the sub grid [BigTile], based on the given
  /// [smallIndex]
  Move.ofIndexSmall(this.state, int smallIndex) {
    xBigTile = 0;
    yBigTile = 0;
    xTile = smallIndex % 3;
    yTile = smallIndex ~/ 3;
  }

  /// Getter method for the big index, usually used in [GameState]
  get bigIndex => yBigTile * 3 + xBigTile;

  /// Getter method for the small index, usually used in [BigTile]
  get smallIndex => yTile * 3 + xTile;


  @override
  String toString() {
    return "$state$xBigTile$yBigTile$xTile$yTile";
  }

  factory Move.fromJson(Map<String, dynamic> json) => _$MoveFromJson(json);

  Map<String, dynamic> toJson() => _$MoveToJson(this);

  @override
  bool operator ==(other) {
    bool equal = other is Move;
    equal = equal && xBigTile == (other as Move).xBigTile;
    equal = equal && yBigTile == (other as Move).yBigTile;
    equal = equal && xTile== (other as Move).xTile;
    equal = equal && yTile == (other as Move).yTile;
    equal = equal && state == (other as Move).state;
    return equal;
  }
}

class RevertMove {
  Move lastMove;
  State bigTileState;

  RevertMove(this.lastMove, this.bigTileState);
}

/// The model for one Tile, a sub element of the grid with a [state]
@JsonSerializable()
class Tile {
  /// The actual state of the Tile
  State state;

  /// Initialises an empty Tile
  Tile() {
    state = State.none;
  }

  /// Initialises a Tile, based on the given [state]
  Tile.fromState(this.state);

  @override
  String toString() {
    return state.toString();
  }

  factory Tile.fromJson(Map<String, dynamic> json) => _$TileFromJson(json);

  Map<String, dynamic> toJson() => _$TileToJson(this);

  @override
  bool operator ==(other) {
    bool equal = other is Tile;
    equal = equal && (other as Tile).state == state;
    return equal;
  }
}

class _TileConverter<T extends Tile> implements JsonConverter<T , Object> {
  const _TileConverter();

  @override
  fromJson(Object json) {
    if(json is Map<String, dynamic> &&
        json.containsKey('tiles')) {
      return BigTile.fromJson(json) as Tile; // Bug in Dart, unnecessary cast
    } else {
      return Tile.fromJson(json);
    }
  }

  @override
  Object toJson(object) {
    return object;
  }
}

/// The Model for a BigTile. It represents a sub grid with a [state]
@JsonSerializable()
class BigTile extends Grid<Tile> implements Tile {
  @override
  State state;

  /// Initialises a BigTile with the given tiles
  BigTile.withTiles(List<Tile> tiles) : super(tiles) {
    state = State.none;
  }

  /// Initialises an empty BigTile
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

  @override
  bool operator ==(other) {
    bool equal = other is BigTile;
    equal = equal && (other as BigTile).state == state;
    for(int i = 0; i < 9; i++)
      equal = equal && (other as BigTile).tiles[i] == tiles[i];
    return equal;
  }

  factory BigTile.fromJson(Map<String, dynamic> json) => _$BigTileFromJson(json);

  Map<String, dynamic> toJson() => _$BigTileToJson(this);

  @override
  String toString() {
    return "BigTile $value";
  }
}

/// The Model for a Grid. It represents a 3x3 grid with Tiles as elements
@JsonSerializable()
class Grid<T extends Tile> {
  /// A list with length of 9, which contains the data
  @JsonKey(name: "tiles")
  @_TileConverter()
  List<T> tiles;

  /// Initialises a Grid with the given Tiles
  Grid(this.tiles)
      : assert(tiles.length == 9,
            "The tiles list has a length of ${tiles.length}");

  /// returns a number that only a identical [Grid] could return
  get value => _getHashFrag(0);

  get playedMoves {
    int i = 0;
    tiles.forEach((t) {
      if (t.state != State.none)
        i++;
    });
    return i;
  }

  int _getHashFrag(int index) {
    if (index == 9) return 0;
    return State.valueOf(tiles[index].state) * pow(3, index) +
        _getHashFrag(index + 1);
  }

  factory Grid.fromJson(Map<String, dynamic> json) => _$GridFromJson(json);

  Map<String, dynamic> toJson() => _$GridToJson(this);
}

/// The Model for a State. It represents a player
class State {
  static final State none = State._(".");
  static final State p1 = State._("X");
  static final State p2 = State._("O");

  /// a string which allows to differentiate between different states
  String _s;

  /// Initialises a State with the String [s]
  State._(String this._s);

  @override
  String toString() {
    return _s;
  }

  /// provides a Value for each State
  static valueOf(State s) {
    if (s == none) return 0;
    if (s == p1) return 1;
    if (s == p2) return 2;
    return -1;
  }

  /// Flips the State to the opposite
  static State flip(State s) {
    if (s == p1) return p2;
    if (s == p2) return p1;
    return none;
  }

  factory State.fromJson(Map<String, dynamic> json) {
    if(json["state"] == p1._s) return p1;
    if(json["state"] == p2._s) return p2;
    return none;
  }

  Map<String, dynamic> toJson() => {"state": this._s};
}
