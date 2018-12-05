import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:uttt_package/src/controller/GameStateController.dart';
import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/controller/algorithms/AlphaBetaCache.dart';

/// Implementation of a Alpha Beta Pruning Algorithm Iterative
class AlphaBetaPruningIterative implements Algorithm {
  int _startTime;
  int milliseconds;
  Heuristic heuristic;
  State _ourState;
  AlphaBetaCache _cache;

  AlphaBetaPruningIterative(this.milliseconds, this.heuristic) {
    _cache = AlphaBetaCache();
  }

  @override
  GameState getNextMove(GameState state) {
    _cache.clear(state.playedMoves + 1);
    _startTime = DateTime.now().millisecondsSinceEpoch;
    if (isGameFinished(state)) return state;
    _ourState = State.flip(state.lastMove.state);
    Move returnMove;
    for(int depth = 0; depth < 20; depth++) {
      Move localBestMove;
      double value = double.negativeInfinity;
      for (Move move in getAllPossibleMoves(state, _ourState)) {
        RevertMove revert = getRevertMove(state, move);
        state = playMove(state, move);
        double alphabeta = _alphabeta(
            state, depth, double.negativeInfinity, double.infinity,
            false);
        if (alphabeta > value) {
          value = alphabeta;
          localBestMove = move;
        }
        revertMove(state, revert);
        if (_timeUp()) return playMove(state, returnMove);
      }
      returnMove = localBestMove;
      print("depth: $depth, cachesize: ${_cache.size}");
    }
    return playMove(state, returnMove);
  }

  double _alphabeta(GameState state, int depth, double alpha, double beta, maximizingPlayer) {
    if (depth == 0 || isGameFinished(state))
      return heuristic.evaluateState(state, _ourState);
    if(_cache.hasAlphaBetaStored(state, depth, alpha, beta, maximizingPlayer))
      return _cache.getAlphaBeta(state, depth, alpha, beta, maximizingPlayer);
    if (maximizingPlayer) {
      double value = double.negativeInfinity;
      for (Move move in getAllPossibleMoves(state, State.flip(state.lastMove.state))) {
        RevertMove revert = getRevertMove(state, move);
        state = playMove(state, move);
        value = max(value, _alphabeta(state, depth - 1, alpha, beta, false));
        revertMove(state, revert);
        if(depth > 3 && _timeUp()) return value;
        alpha = max(alpha, value);
        if (alpha >= beta) {
          break;
        }
      }
      return _cache.storeAlphaBeta(value, state, depth, alpha, beta, maximizingPlayer);
    } else {
      double value = double.infinity;
      for (Move move in getAllPossibleMoves(state, State.flip(state.lastMove.state))) {
        RevertMove revert = getRevertMove(state, move);
        state = playMove(state, move);
        value = min(value, _alphabeta(state, depth - 1, alpha, beta, true));
        revertMove(state, revert);
        if(depth > 3 && _timeUp()) return value;
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

  factory AlphaBetaPruningIterative.fromJson(Map<String, dynamic> json) {
    return AlphaBetaPruningIterative(json["milliseconds"], Heuristic.fromJson(json["heuristic"]));
  }

  Map<String, dynamic> toJson() {
    return {
        "milliseconds": milliseconds,
        "heuristic": heuristic.toJson(),
        "class": "AlphaBetaPruningIterative",
      };
  }
}

