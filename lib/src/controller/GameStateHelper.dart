import 'package:uttt/src/controller/GameStateController.dart';
import 'package:uttt/src/model/GameState.dart';
import 'dart:math';

class GameStateHelper {
  static GameState getRandomField(int moves) {
    GameState gameState = new GameState();
    for(int i = 0; i < moves; i++) {
      List<Move> moveList = GameStateController.getAllPossibleMoves(gameState);
      int random = Random.secure().nextInt(moveList.length);
      Move randomMove = moveList.elementAt(random);
      gameState = GameStateController.playMove(gameState, randomMove);
    }
  }
}