import 'package:uttt_package/src/controller/GameStateController.dart';
import 'package:uttt_package/src/model/GameState.dart';
import 'dart:math';

class GameStateHelper {
  static GameState getRandomField(int moves) {
    GameState gameState = new GameState();
    for(int i = 0; i < moves; i++) {
      List<Move> moveList = getAllPossibleMoves(gameState);
      int random = Random.secure().nextInt(moveList.length);
      Move randomMove = moveList.elementAt(random);
      gameState = playMove(gameState, randomMove);
    }
    return gameState;
  }
}