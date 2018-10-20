import 'package:uttt/src/model/GameState.dart';
import 'package:uttt/src/model/Player.dart';
import 'package:uttt/src/controller/GameStateController.dart';
import 'package:uttt/src/controller/GridCache.dart';

class Game {
  Player _player1;
  Player _player2;
  GameState gameState;
  int move;

  Game(this._player1, this._player2) {
    gameState = GameState();
    move = 0;
  }

  void start() {
    p2Played(gameState);
  }

  void p1Played(GameState state) {
    _validate(state);
    if (!isGameFinished(state)) _player2.playMove(state, p2Played);
  }

  void p2Played(GameState state) {
    _validate(state);
    if (!isGameFinished(state)) _player1.playMove(state, p1Played);
  }

  //TODO ausbauen, dass sinnvoll validiert wird.
  void _validate(GameState state) {
    print("-----------| Move ${move++} |-----------");
    visualize(state);
    print("");
    print("-----------| Winner ${cache[state.value].winner} |-----------");
    print("");
  }
}
