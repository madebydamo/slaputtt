import 'dart:collection';

import 'package:uttt_package/src/model/GameState.dart';

class AlphaBetaCache {
  SplayTreeMap<_AlphaBetaFunctionCall, double> _cache;
  int _finds;


  AlphaBetaCache() {
    _cache = SplayTreeMap();
    _finds = 0;
  }

  bool hasAlphaBetaStored(GameState state, int depth, double alpha, double beta, maximizingPlayer) {
    return _cache.containsKey(
        _getFunctionCall(state, depth));
  }

  double getAlphaBeta(GameState state, int depth, double alpha, double beta, maximizingPlayer) {
    _finds++;
    return _cache[_getFunctionCall(state, depth)];
  }

  double storeAlphaBeta(double value, GameState state, int depth, double alpha, double beta, maximizingPlayer) {
    if (depth > 2)
      _cache.putIfAbsent(_getFunctionCall(state, depth), () => value);
    return value;
  }

  _AlphaBetaFunctionCall _getFunctionCall(GameState state, int depth) {
    return _AlphaBetaFunctionCall(
        state.toCompactString(), state.playedMoves, depth);
  }

  int get size => _cache.length;

  void clear(int playedMoves) {
    int i = _cache.length;
    _cache.removeWhere((key, value) => key.playedMoves < playedMoves);
    print("Removed ${i - _cache.length} items, $_finds found");
    _finds = 0;
  }
}

class _AlphaBetaFunctionCall extends Comparable<_AlphaBetaFunctionCall>{
  String state;
  int playedMoves;
  int depth;

  _AlphaBetaFunctionCall(this.state,
      this.playedMoves,
      this.depth) {
  }

  @override
  bool operator ==(other) {
    return other is _AlphaBetaFunctionCall
        && other.playedMoves == playedMoves
    && other.state == state
    && other.depth == depth;
  }

  @override
  int get hashCode {
    return state.hashCode + playedMoves.hashCode * 13 + depth.hashCode * 61;
  }

  @override
  int compareTo(_AlphaBetaFunctionCall other) {
    if(playedMoves == other.playedMoves) {
      if(depth == other.depth)
        return state.compareTo(other.state);
      else
        return depth.compareTo(other.depth);
    } else {
      return playedMoves.compareTo(other.playedMoves);
    }
  }
}