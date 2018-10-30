import "package:test/test.dart";
import 'package:uttt_package/src/controller/GameStateController.dart';
import 'package:uttt_package/src/controller/GameStateHelper.dart';
import 'package:uttt_package/src/model/GameState.dart';

void main() {
  group("Tests method isGameFinished", () {
    test("newGame", () {
      GameState newGameState = new GameState();
      expect(isGameFinished(newGameState), false);
    });
    test("Some moves played", () {
      GameState randomGameState = GameStateHelper.getRandomField(5);
      expect(isGameFinished(randomGameState), false);
    });
    test("Some moves played", () {
      GameState gameState = new GameState();
      //TODO
      expect(isGameFinished(gameState), true);
    });
  });
}