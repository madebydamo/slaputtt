import 'dart:collection';
import 'dart:convert';

import 'package:uttt_package/src/controller/GameStateController.dart';
import 'package:uttt_package/src/controller/GridCache.dart';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/model/Player.dart';

typedef TerminateGameArgument(State winner);

/// Provides a Game between two [Player]
class Game {
  Player _player1;
  Player _player2;
  GameState gameState;
  int _move;
  Player winner;
  Map<State, Player> playerFromState;
  TerminateGameArgument onTerminate;
  Queue<RevertMove> playedMoves;

  /// Initialises a new Game
  Game(this._player1, this._player2, [this.onTerminate]) {
    gameState = GameState();
    _move = 0;
    playerFromState = {
      State.p1: _player1,
      State.p2: _player2,
      State.none: null
    };
    playedMoves = Queue();
  }

  /// Starts the game
  void start() async {
    await _p2Played();
  }

  void terminate() {
    winner = playerFromState[cache[gameState.value].winner];
    _player1.terminate(gameState, winner == _player1, winner == null);
    _player2.terminate(gameState, winner == _player2, winner == null);
    if (onTerminate != null)
      onTerminate(cache[gameState.value].winner);
  }

  /// Gets called, when [_player1] had played and it's [_player2]'s turn to play
  /// Also gets called, when the Game starts
  void _p1Played() async {
    if (!isGameFinished(gameState)) {
      Move move = await _player2.playMove(
          GameState.fromJson(json.decode(json.encode(gameState.toJson()))));
      playedMoves.add(playMove(gameState, move));
      if (!_validate(gameState)) {
        revertMove(gameState, playedMoves.removeLast());
        await _p1Played();
      } else {
        await _p2Played();
      }
    } else terminate();
  }

  /// Gets called, when [_player2] had played and it's [_player1]'s turn to play
  void _p2Played() async {
    if (!isGameFinished(gameState)) {
      Move move = await _player1.playMove(
          GameState.fromJson(json.decode(json.encode(gameState.toJson()))));
      playedMoves.add(playMove(gameState, move));
      if (!_validate(gameState)) {
        revertMove(gameState, playedMoves.removeLast());
        await _p2Played();
      } else {
        await _p1Played();
      }
    } else terminate();
  }

  /// Validates whether the played Move was valid or not.
  bool _validate(GameState state) {
    //TODO
    _move++;
//    print("-----------| Move ${_move++} |-----------");
//    visualize(state);
//    print("");
//    print("-----------| Winner ${cache[state.value].winner} |-----------");
//    print("");
    if (_move == 1) {
      return true;
    } else {
      return true;
    }
  }
}
