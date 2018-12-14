import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruningIterative.dart';
import 'package:uttt_package/src/controller/algorithms/RandomMove.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import 'package:uttt_package/src/model/GameState.dart';

///The Algorithm is used for all different algorithms. They become the
///[GameState] and calculate the next move out of that.
abstract class Algorithm {

  Move getNextMove(GameState state);

  Map<String, dynamic> toJson();

  static Algorithm fromJson(Map<String, dynamic> json) {
    if (json["class"] == "AlphaBetaPruning")
      return AlphaBetaPruning.fromJson(json);
    if (json["class"] == "AlphaBetaPruningIterative")
      return AlphaBetaPruningIterative.fromJson(json);
    return RandomMove.fromJson(json);
  }
}

abstract class Heuristic {

  double evaluateState(GameState state, State primaryState);

  Map<String, dynamic> toJson();

  static Heuristic fromJson(Map<String, dynamic> json) {
    return HeuristicAlphaBeta.fromJson(json);
  }
}