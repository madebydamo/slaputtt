import 'package:uttt/src/model/Algorithm.dart';
import 'package:uttt/src/model/GameState.dart';
import 'package:uttt/src/controller/GameStateController.dart';
import 'dart:math';

class RandomMove extends Algorithm {
  Random r;

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
