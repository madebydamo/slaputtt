import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/controller/GameStateController.dart';
import 'dart:math';

/// Implementation of a Random Algorithm, which plays a random possible move
class RandomMove extends Algorithm {
  Random r;

  /// Initialises a new Random Algorithm
  RandomMove() {
    r = Random();
  }

  @override
  GameState getNextMove(GameState state) {
    List<Move> moves = getAllPossibleMovesWithStates(state, State.flip(state.lastMove.state));
    int randomIndex = r.nextInt(moves.length);
    return playMove(state, moves[randomIndex]);
  }
}
