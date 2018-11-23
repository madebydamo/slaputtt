import 'dart:html';

import 'package:uttt_package/src/model/Algorithm.dart';

import '../../transmission/Transmission.dart';

void _log(e) => print("GameSimulator: $e");

class GameSimulator {
  Worker _worker;

  GameSimulator(Algorithm algorithm) {
    _worker = new Worker("worker/game/workerScript.js");
    _worker.onMessage.listen((e) {
      _log(e.data);
      Transmission transmission = Transmission.fromTransmittable(e.data);
      if (transmission.typ == typ_initialised) {
        dynamic json = Transmission.configAlgorithm(algorithm)
            .toTransmittable();
        _log(json);
        _worker.postMessage(json);
      }
    });
  }
}