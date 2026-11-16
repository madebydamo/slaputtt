import 'package:uttt_package/src/controller/Game.dart';
import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';

import 'WebPlayer.dart';
import '../worker/algorithm/AlgorithmWorker.dart';
import '../components/Telemetry.dart';

class GameController {
  static GameController _controller;
  Algorithm opponent;
  WebPlayer player = WebPlayer();
  AlgorithmWorker worker;
  // For the browser events: the opponent's level (easy|medium|hard on the
  // play page, best = last generation's best, picked = chosen in the list),
  // how it was trained (ga = genetic algorithm, pso = particle swarm) and
  // its search depth.
  String level = 'best';
  String ai = 'ga';
  int depth = 3;

  GameController._() {}

  factory GameController() {
    if (_controller == null) _controller = GameController._();
    return _controller;
  }

  void config(Algorithm algorithm, [bool startGame = false]) {
    if (algorithm is AlphaBetaPruning) depth = algorithm.depth;
    if (worker == null) {
      if (startGame)
        worker = AlgorithmWorker(
            algorithm: algorithm, afterConfiguration: this.startGame);
      else
        worker = AlgorithmWorker(algorithm: algorithm);
    } else {
      if (startGame)
        worker.config(algorithm, this.startGame);
      else
        worker.config(algorithm);
    }
  }

  void startGame() {
    track('game/start/$level/$ai/$depth');
    Game(player, worker).start();
  }

  void gameEnded(bool won, bool draw) {
    String result = won ? 'won' : (draw ? 'draw' : 'lost');
    track('game/end/$result/$level/$ai');
  }
}
