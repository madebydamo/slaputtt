import 'package:uttt_package/src/controller/GameStateController.dart';
import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/controller/GridCache.dart';
import 'dart:math';

/// Implementation of a Alpha Beta Pruning Algorithm
class AlphaBetaPruning implements Algorithm {
  int _depth;
  Heuristic heuristic;
  State _ourState;

  AlphaBetaPruning(this._depth, this.heuristic);

  @override
  GameState getNextMove(GameState state) {
    if (isGameFinished(state)) return state;
    _ourState = State.flip(state.lastMove.state);
    Move returnMove;
    double value = double.negativeInfinity;
    for (Move move in getAllPossibleMovesWithStates(state, _ourState)) {
      Move oldMove = state.lastMove;
      GameState newState = playMove(state, move);
      double alphabeta = _alphabeta(
          newState, _depth, double.negativeInfinity, double.infinity, false);
      if (alphabeta > value) {
        value = alphabeta;
        returnMove = move;
      }
      _revertMove(newState, oldMove);
    }
    return playMove(state, returnMove);
  }

  double _alphabeta(GameState state, int depth, double alpha, double beta, maximizingPlayer) {
    if (depth == 0 || isGameFinished(state))
      return heuristic.evaluateState(state, _ourState);
    if (maximizingPlayer) {
      double value = double.negativeInfinity;
      for (Move move in getAllPossibleMovesWithStates(state, State.flip(state.lastMove.state))) {
        Move oldMove = state.lastMove;
        GameState newState = playMove(state, move);
        value = max(value, _alphabeta(newState, depth - 1, alpha, beta, false));
        _revertMove(state, oldMove);
        alpha = max(alpha, value);
        if (alpha >= beta) {
          break;
        }
      }
      return value;
    } else {
      double value = double.infinity;
      for (Move move in getAllPossibleMovesWithStates(state, State.flip(state.lastMove.state))) {
        Move oldMove = state.lastMove;
        GameState newState = playMove(state, move);
        value = min(value, _alphabeta(newState, depth - 1, alpha, beta, true));
        _revertMove(state, oldMove);
        beta = min(beta, value);
        if (alpha >= beta) {
          break;
        }
      }
      return value;
    }
  }

  void _revertMove(GameState state, Move oldMove) {
    Move revertMove = state.lastMove;
    state.tiles[revertMove.bigIndex].tiles[revertMove.smallIndex].state = State.none;
    state.lastMove = oldMove;
    var _gridInfo = cache[state.tiles[revertMove.bigIndex].value];
    state.tiles[revertMove.bigIndex].state = _gridInfo.winner;
  }
}
