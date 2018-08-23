import "package:test/test.dart";
import 'package:uttt/src/controller/GameStateController.dart';
import 'package:uttt/src/controller/GameStateHelper.dart';
import 'package:uttt/src/model/GameState.dart';

void main() {
  group("Tests method isGameFinished", () {
    test("newGame", () {
      GameState newGameState = new GameState();
      expect(GameStateController.isGameFinished(newGameState), false);
    });
    test("Some moves played", () {
      GameState randomGameState = GameStateHelper.getRandomField(5);
      expect(GameStateController.isGameFinished(randomGameState), false);
    });
    test("Some moves played", () {
      GameState gameState = new GameState();
      //TODO
      expect(GameStateController.isGameFinished(gameState), true);
    });
  });
}