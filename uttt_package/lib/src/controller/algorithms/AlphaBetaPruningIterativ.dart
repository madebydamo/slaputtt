import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:uttt_package/src/controller/GameStateController.dart';
import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/controller/algorithms/AlphaBetaCache.dart';

/// Implementation of a Alpha Beta Pruning Algorithm
///
@JsonSerializable()
class AlphaBetaPruning implements Algorithm {
  int _startTime;
  int milliseconds;
  Heuristic heuristic;
  State ourState;
  AlphaBetaCache _cache;

  AlphaBetaPruning(this.milliseconds, this.heuristic) {
     _cache = AlphaBetaCache();
  }

  @override
  GameState getNextMove(GameState state) {
    _startTime = DateTime.now().millisecondsSinceEpoch;
    if (isGameFinished(state)) return state;
    ourState = State.flip(state.lastMove.state);
    Move returnMove;
    double value = double.negativeInfinity;
    for (Move move in getAllPossibleMovesWithStates(state, ourState)) {
      RevertMove revert = getRevertMove(state, move);
      state = playMove(state, move);
      double alphabeta = _alphabeta(
          state, milliseconds, double.negativeInfinity, double.infinity, false);
      if (alphabeta > value) {
        value = alphabeta;
        returnMove = move;
      }
      revertMove(state, revert);
    }
    return playMove(state, returnMove);
  }

  double _alphabeta(GameState state, int depth, double alpha, double beta, maximizingPlayer) {
    if(_cache.hasAlphaBetaStored(state, depth, alpha, beta, maximizingPlayer))
      return _cache.getAlphaBeta(state, depth, alpha, beta, maximizingPlayer);
    if (depth == 0 || isGameFinished(state))
      return _cache.storeAlphaBeta(heuristic.evaluateState(state, ourState), state, depth, alpha, beta, maximizingPlayer);
    if (maximizingPlayer) {
      double value = double.negativeInfinity;
      for (Move move in getAllPossibleMovesWithStates(state, State.flip(state.lastMove.state))) {
        RevertMove revert = getRevertMove(state, move);
        state = playMove(state, move);
        value = max(value, _alphabeta(state, depth - 1, alpha, beta, false));
        if(_timeUp()) return double.negativeInfinity;
        revertMove(state, revert);
        alpha = max(alpha, value);
        if (alpha >= beta) {
          break;
        }
      }
      return _cache.storeAlphaBeta(value, state, depth, alpha, beta, maximizingPlayer);
    } else {
      double value = double.infinity;
      for (Move move in getAllPossibleMovesWithStates(state, State.flip(state.lastMove.state))) {
        RevertMove revert = getRevertMove(state, move);
        state = playMove(state, move);
        value = min(value, _alphabeta(state, depth - 1, alpha, beta, true));
        if(_timeUp()) return double.infinity;
        revertMove(state, revert);
        beta = min(beta, value);
        if (alpha >= beta) {
          break;
        }
      }
      return _cache.storeAlphaBeta(value, state, depth, alpha, beta, maximizingPlayer);
    }
  }

  bool _timeUp() {
    return DateTime.now().millisecondsSinceEpoch - _startTime > milliseconds;
  }

  factory AlphaBetaPruning.fromJson(Map<String, dynamic> json) {
    return AlphaBetaPruning(json["depth"], Heuristic.fromJson(json["heuristic"]));
  }

  Map<String, dynamic> toJson() {
    return {
        "depth": milliseconds,
        "heuristic": heuristic.toJson(),
        "class": "AlphaBetaPruning",
      };
  }
}

