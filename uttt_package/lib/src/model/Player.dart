import 'package:uttt_package/src/model/GameState.dart';
import 'dart:async';

/// A Interface for Players, where they get the current [GameState] and a
/// function, where they can return the new [GameState].
abstract class Player {
  ///Gives the [Player] the current [state] of the [Game] and a function, where
  ///they can return the new [GameState].
  Future<Move> playMove(GameState state);

  ///Gets invoked, when the game has finished. [won] contains the information
  ///whether the [Player] have won the game. [state] is the current GameState.
  terminate(GameState state, bool won);
}
