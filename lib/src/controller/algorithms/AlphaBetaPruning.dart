import 'package:uttt/src/controller/GameStateController.dart';
import 'package:uttt/src/model/Algorithm.dart';
import 'package:uttt/src/model/GameState.dart';
import 'dart:math';

class AlphaBetaPrunning implements Algorithm {
  @override
  GameState getNextMove(GameState state) {
    if (GameStateController.isGameFinished(state)) return state;
    GameState returnState = state;
    double value = double.negativeInfinity;
    for (Move move in GameStateController.getAllPossibleMoves(state)) {
      GameState newState = GameStateController.playMove(state, move);
      double alphabeta = _alphabeta(
          newState, 6, double.negativeInfinity, double.infinity, true);
      if (alphabeta > value) {
        value = alphabeta;
        returnState = newState;
      }
    }
    return returnState;
  }

  double _alphabeta(GameState state, int depth, double alpha, double beta, maximizingPlayer) {
    if (depth == 0 || GameStateController.isGameFinished(state))
      return GameStateController.evaluateValue(state);
    if (maximizingPlayer) {
      double value = double.negativeInfinity;
      for (Move move in GameStateController.getAllPossibleMoves(state)) {
        GameState newState = GameStateController.playMove(state, move);
        value = max(value, _alphabeta(newState, depth - 1, alpha, beta, false));
        alpha = max(alpha, value);
        if (alpha >= beta) {
          break;
        }
      }
      return value;
    } else {
      double value = double.infinity;
      for (Move move in GameStateController.getAllPossibleMoves(state)) {
        GameState newState = GameStateController.playMove(state, move);
        value = max(value, _alphabeta(newState, depth - 1, alpha, beta, true));
        beta = max(beta, value);
        if (alpha >= beta) {
          break;
        }
      }
      return value;
    }
  }
}
