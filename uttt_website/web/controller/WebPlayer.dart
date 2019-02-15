import 'dart:async';
import 'dart:html';

import 'package:uttt_package/src/controller/GameStateController.dart'
    as GameController;
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/model/Player.dart';

import '../components/GameOverModal.dart';
import '../components/Grid.dart';

class WebPlayer implements Player {
  GameState _state;
  Completer<Move> _completer;
  GridElement _grid;

  WebPlayer() {
    _grid = GridElement((event, bigIndex, smallIndex) {
      if (_state != null) {
        Move m = Move.ofIndex(State.p1, bigIndex, smallIndex);
        if (GameController.getAllPossibleMoves(_state).contains(m)) {
          GameController.playMove(_state, m);
          _grid.visualize(_state, false);
          _completer.complete(m);
        }
      }
    });
  }

  @override
  playMove(GameState state) {
    _completer = Completer();
    _state = state;
    _grid.visualize(state);
    return _completer.future;
  }

  @override
  terminate(GameState state, bool won, bool draw) {
    print("Terminated, you have won: $won");
    _grid.visualize(state, false);
    GameOverModal modal = GameOverModal();
    modal.open(won, draw);
  }
}
