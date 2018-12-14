import 'dart:math';

import 'package:uttt_package/src/controller/GameStateController.dart';
import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/model/GameState.dart';

/// Implementation of a Random Algorithm, which plays a random possible move
class RandomMove extends Algorithm {
  Random r;

  /// Initialises a new Random Algorithm
  RandomMove() {
    r = Random();
  }

  @override
  Move getNextMove(GameState state) {
    List<Move> moves = getAllPossibleMoves(state, State.flip(state.lastMove.state));
    int randomIndex = r.nextInt(moves.length);
    return moves[randomIndex];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "class": "RandomMove",
    };
  }

  RandomMove.fromJson(Map<String, dynamic> json) : this();
}
