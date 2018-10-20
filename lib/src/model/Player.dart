import 'package:uttt/src/model/GameState.dart';

typedef void GameStateArgument(GameState s);

abstract class Player {
  playMove(GameState state, GameStateArgument s);
}