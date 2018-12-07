import 'dart:html';

import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/model/GameState.dart';

import '../../transmission/Transmission.dart';

typedef List<Algorithm> NextAlgorithms();
typedef ReturnWinner(State s, List<Algorithm> players);

void _log(e) => print("GameSimulator: $e");

class GameSimulator {
  Worker _worker;
  NextAlgorithms next;
  ReturnWinner returner;
  List<Algorithm> algorithms;

  GameSimulator(this.next, this.returner) {
    _worker = new Worker("worker/game/workerScript.js");
    _worker.onMessage.listen((e) {
      _log(e.data);
      Transmission transmission = Transmission.fromTransmittable(e.data);
      if (transmission.typ == typ_initialised) {
        evaluateGame();
      } else if (transmission.typ == typ_gameWinner) {
        returner(transmission.object, algorithms);
        evaluateGame();
      }
    });
  }

  playGame(Algorithm algorithm1, Algorithm algorithm2) {
    _worker.postMessage(Transmission.playGame(algorithm1, algorithm2).toTransmittable());
  }

  evaluateGame() {
    algorithms = next();
    if(algorithms != null)
      _worker.postMessage(Transmission.playGame(algorithms[0], algorithms[1]).toTransmittable());
  }
}