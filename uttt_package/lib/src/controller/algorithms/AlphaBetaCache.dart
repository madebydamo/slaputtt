import 'package:uttt_package/src/model/GameState.dart';

class AlphaBetaCache {
  Map<String, double> _cache;


  AlphaBetaCache() {
    _cache = Map();
  }

  bool hasAlphaBetaStored(GameState state, int depth, double alpha, double beta, maximizingPlayer) {
    return _cache.containsKey(
        _getMethodString(state, depth, alpha, beta, maximizingPlayer));
  }

  double getAlphaBeta(GameState state, int depth, double alpha, double beta, maximizingPlayer) {
    return _cache[_getMethodString(
        state, depth, alpha, beta, maximizingPlayer)];
  }

  double storeAlphaBeta(double value, GameState state, int depth, double alpha, double beta, maximizingPlayer) {
    _cache.putIfAbsent(_getMethodString(
        state, depth, alpha, beta, maximizingPlayer), () => value);
    return value;
  }

  String _getMethodString(GameState state, int depth, double alpha, double beta,
      maximizingPlayer) {
    return "${state.toCompactString()}|$depth|$alpha|$beta|$maximizingPlayer";
  }

  int get size => _cache.length;

  void clear(int playedMoves) {
    //TODO funktioniert noch nicht.
    int i = _cache.length;
    _cache.removeWhere((key, value) =>
    int.parse(key.substring(0, 2)) < playedMoves);
    print("Removed ${i - _cache.length} items");
  }
}