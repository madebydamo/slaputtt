import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/model/Player.dart';
import 'package:uttt_package/src/controller/GameStateController.dart';
import 'package:uttt_package/src/controller/GridCache.dart';

/// Provides a Game between two [Player]
class Game {
  Player _player1;
  Player _player2;
  GameState gameState;
  int _move;
  Player winner;
  Map<State, Player> playerFromState;

  /// Initialises a new Game
  Game(this._player1, this._player2) {
    gameState = GameState();
    _move = 0;
    playerFromState = {
      State.p1: _player1,
      State.p2: _player2,
      State.none: null
    };
  }

  /// Starts the game
  void start() {
    _p2Played(gameState);
    winner = playerFromState[cache[gameState.value].winner];
    _player1.terminate(gameState, winner == _player1);
    _player2.terminate(gameState, winner == _player2);
//    print("-----------| Winner ${cache[gameState.value].winner} |-----------");
  }

  /// Gets called, when [_player1] had played and it's [_player2]'s turn to play
  /// Also gets called, when the Game starts
  void _p1Played(GameState state) {
    if (!_validate(state)) {
      _p1Played(state);
    }
    if (!isGameFinished(state)) _player2.playMove(state, _p2Played);
  }

  /// Gets called, when [_player2] had played and it's [_player1]'s turn to play
  void _p2Played(GameState state) {
    if (!_validate(state)) {
      _p2Played(state);
    }
    if (!isGameFinished(state)) _player1.playMove(state, _p1Played);
  }

  /// Validates whether the played Move was valid or not.
  bool _validate(GameState state) {
    _move++;
//    print("-----------| Move ${_move++} |-----------");
//    visualize(state);
//    print("");
//    print("-----------| Winner ${cache[state.value].winner} |-----------");
//    print("");
    if (_move == 1 || playMove(gameState, state.lastMove) == state) {
      gameState = state;
      return true;
    } else {
      return false;
    }
  }
}
