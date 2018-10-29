import 'package:uttt/src/model/Algorithm.dart';
import 'package:uttt/src/model/GameState.dart';
import 'package:uttt/src/model/Player.dart';

class Computer implements Player {

  Algorithm algorithm;

  Computer(this.algorithm);

  @override
  playMove(GameState state, GameStateArgument s) {
    s(algorithm.getNextMove(state));
  }
}