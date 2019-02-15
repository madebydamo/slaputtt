import 'dart:async';
import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/model/Player.dart';

class Computer implements Player {

  Algorithm algorithm;

  Computer(this.algorithm);

  @override
  Future<Move> playMove(GameState state) {
    return Future.sync(() => algorithm.getNextMove(state));
  }

  @override
  terminate(GameState state, bool won, bool draw) {
    //Nothing to do here
  }
}