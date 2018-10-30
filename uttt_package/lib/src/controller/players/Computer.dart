import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/model/Player.dart';

class Computer implements Player {

  Algorithm algorithm;

  Computer(this.algorithm);

  @override
  playMove(GameState state, GameStateArgument s) {
    s(algorithm.getNextMove(state));
  }
}