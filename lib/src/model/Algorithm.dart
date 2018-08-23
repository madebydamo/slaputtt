import 'package:uttt/src/model/GameState.dart';

abstract class Algorithm {
  GameState getNextMove(GameState state);
}