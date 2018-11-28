import 'package:uttt_package/src/model/GameState.dart';

class AlphaBetaCache {
  Map<_AlphaBetaFunctionCall, double> _cache;
  int _finds;


  AlphaBetaCache() {
    _cache = Map();
    _finds = 0;
  }

  bool hasAlphaBetaStored(GameState state, int depth, double alpha, double beta, maximizingPlayer) {
    return _cache.containsKey(
        _getFunctionCall(state, depth, alpha, beta, maximizingPlayer));
  }

  double getAlphaBeta(GameState state, int depth, double alpha, double beta, maximizingPlayer) {
    _finds++;
    return _cache[_getFunctionCall(
        state, depth, alpha, beta, maximizingPlayer)];
  }

  double storeAlphaBeta(double value, GameState state, int depth, double alpha, double beta, maximizingPlayer) {
    _cache.putIfAbsent(_getFunctionCall(
        state, depth, alpha, beta, maximizingPlayer), () => value);
    return value;
  }

  _AlphaBetaFunctionCall _getFunctionCall(GameState state, int depth,
      double alpha, double beta,
      maximizingPlayer) {
    return _AlphaBetaFunctionCall(
        state.toCompactString(), state.playedMoves, depth, alpha, beta,
        maximizingPlayer);
  }

  int get size => _cache.length;

  void clear(int playedMoves) {
    //TODO funktioniert noch nicht.
    int i = _cache.length;
    _cache.removeWhere((key, value) => key.movesPlayed < playedMoves);
    print("Removed ${i - _cache.length} items, $_finds found");
    _finds = 0;
  }
}

class _AlphaBetaFunctionCall {
  String state;
  int movesPlayed;
  int depth;
  double alpha;
  double beta;
  bool maximizingPlayer;

  _AlphaBetaFunctionCall(this.state,
      this.movesPlayed,
      this.depth,
      this.alpha,
      this.beta,
      this.maximizingPlayer);

  @override
  bool operator ==(other) {
    return other is _AlphaBetaFunctionCall
    && other.movesPlayed == movesPlayed
    && other.state == state
    && other.depth == depth
//    && other.alpha == alpha
//    && other.beta == beta
    && other.maximizingPlayer == maximizingPlayer;
  }

  @override
  int get hashCode {
    return state.hashCode + movesPlayed.hashCode * 13 + depth.hashCode * 37 + depth.hashCode * 61 + maximizingPlayer.hashCode * 17;
  }
}