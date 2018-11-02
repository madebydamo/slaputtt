import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/controller/GridCache.dart';

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
    s += state.tiles
        .elementAt(subrow * 3 + subcolumn)
        .tiles
        .elementAt(subsubrow * 3 + subsubcolumn)
        .state
        .toString();
  }
  print(s);
}

bool isGameFinished(GameState state) {
  if (cache[state.value].isFinished) return true;
  return getAllPossibleMoves(state).length == 0;
}

List<Move> getAllPossibleMoves(GameState state) {
  List<Move> moves = [];
  if (state.lastMove == Move.init ||
      cache[state.tiles[state.lastMove.smallIndex].value].isFinished) {
    for (int i = 0; i < 9; i++) {
      BigTile current = state.tiles[i];
      List<Move> m = cache[current.value].moves;
      moves.addAll(m.map((m) =>
          Move.ofIndex(State.flip(state.lastMove.state), i, m.smallIndex)));
    }
  } else {
    List<Move> m = cache[state.tiles[state.lastMove.smallIndex].value].moves;
    moves.addAll(m.map((m) => Move.ofIndex(State.flip(state.lastMove.state),
        state.lastMove.smallIndex, m.smallIndex)));
  }
  return moves;
}

List<Move> getAllPossibleMovesWithStates(GameState state, State s) {
  List<Move> moves = getAllPossibleMoves(state);
  moves.forEach((m) => m.state = s);
  return moves;
}

GameState playMove(GameState state, Move move) {
  state.tiles[move.bigIndex].tiles[move.smallIndex].state = move.state;
  state.lastMove = move;
  var _gridInfo = cache[state.tiles[move.bigIndex].value];
  if(_gridInfo.isFinished) {
    state.tiles[move.bigIndex].state = _gridInfo.winner;
  }
  return state;
}
