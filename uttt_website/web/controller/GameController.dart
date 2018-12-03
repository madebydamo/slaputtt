import 'package:uttt_package/src/controller/Game.dart';
import 'package:uttt_package/src/model/Algorithm.dart';

import '../components/Grid.dart';
import 'WebPlayer.dart';
import '../worker/algorithm/AlgorithmWorker.dart';

class GameController {
  static GameController _controller;
  Algorithm opponent;
  WebPlayer player = WebPlayer();
  AlgorithmWorker worker;

  GameController._() {}

  factory GameController() {
    if (_controller == null) _controller = GameController._();
    return _controller;
  }

  void config(Algorithm algorithm, [bool startGame = false]) {
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
    Game(player, worker).start();
  }
}
