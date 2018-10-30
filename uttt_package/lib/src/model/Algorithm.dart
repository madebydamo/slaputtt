import 'package:uttt_package/src/model/GameState.dart';

abstract class Algorithm {
  //TODO Probably change to Returntype Move
  GameState getNextMove(GameState state);
}