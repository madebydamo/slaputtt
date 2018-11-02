import 'package:uttt_package/src/model/GameState.dart';

///The Algorithm is used for all different algorithms. They become the
///[GameState] and calculate the next move out of that.
abstract class Algorithm {
  //TODO Probably change to Returntype Move
  GameState getNextMove(GameState state);
}

abstract class Heuristic {

  double evaluateState(GameState state, State primaryState);
}