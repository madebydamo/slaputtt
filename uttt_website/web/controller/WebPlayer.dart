import 'dart:html';

import 'package:uttt_package/src/controller/GameStateController.dart'
    as GameController;
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/model/Player.dart';

import '../components/Grid.dart';

class WebPlayer implements Player {
  GameState _state;
  GameStateArgument _s;
  GridElement _grid;

  WebPlayer() {
    _grid = GridElement((event, bigIndex, smallIndex) {
      if (_state != null) {
        Move m = Move.ofIndex(State.p1, bigIndex, smallIndex);
        if (GameController.getAllPossibleMoves(_state).contains(m)) {
          GameController.playMove(_state, m);
          _grid.visualize(_state, false);
          _s(_state);
        }
      }
    });
  }

  @override
  playMove(GameState state, GameStateArgument s) {
    _state = state;
    _s = s;
    _grid.visualize(state);
  }

  @override
  terminate(GameState state, bool won) {
    print("Terminated, you have won: $won");
    querySelector("#winner").innerHtml =
        won ? "Congrats, you have won!" : "Maybe next time...";
    _grid.visualize(state, false);
  }
}
