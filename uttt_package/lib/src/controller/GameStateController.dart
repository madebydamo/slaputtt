import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/controller/GridCache.dart';
import 'package:uttt_package/src/controller/CacheTools.dart';

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

List<Move> getAllPossibleMoves(GameState state, [State s]) {
  if (cache[state.value].isFinished) return [];
  List<Move> moves = [];
  if (state.lastMove == Move.init ||
      cache[state.tiles[state.lastMove.smallIndex].value].isFinished) {
    for (int i = 0; i < 9; i++) {
      BigTile current = state.tiles[i];
      List<Move> m = cache[current.value].moves;
      moves.addAll(m.map((m) =>
          Move.ofIndex(State.flip(state.lastMove.state), i, m.smallIndex)));
    }
    moves.sort((a, b) {
      return getMoveValue(a).compareTo(getMoveValue(b));
    });
  } else {
    List<Move> m = cache[state.tiles[state.lastMove.smallIndex].value].moves;
    moves.addAll(m.map((m) => Move.ofIndex(State.flip(state.lastMove.state),
        state.lastMove.smallIndex, m.smallIndex)));
  }
  if (s != null)
    moves.forEach((m) => m.state = s);
  return moves;
}

RevertMove getRevertMove(GameState state, Move move) {
  return RevertMove(state.lastMove, state.tiles[move.bigIndex].state);
}

GameState revertMove(GameState state, RevertMove revertMove) {
  Move moveToDelete = state.lastMove;
  state.tiles[moveToDelete.bigIndex].tiles[moveToDelete.smallIndex].state = State.none;
  state.lastMove = revertMove.lastMove;
  state.tiles[moveToDelete.bigIndex].state = revertMove.bigTileState;
  return state;
}

RevertMove playMove(GameState state, Move move) {
  RevertMove revertMove = getRevertMove(state, move);
  state.tiles[move.bigIndex].tiles[move.smallIndex].state = move.state;
  state.lastMove = move;
  var _gridInfo = cache[state.tiles[move.bigIndex].value];
  if(_gridInfo.isFinished) {
    state.tiles[move.bigIndex].state = _gridInfo.winner;
  }
  return revertMove;
}
