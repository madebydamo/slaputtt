import 'dart:html';

import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/model/Player.dart';

import '../../transmission/Transmission.dart';

void _log(e) => print("Frontend: $e");

class AlgorithmWorker implements Player {
  Worker _worker;
  GameStateArgument _s;

  void Function() _afterConfiguration;

  AlgorithmWorker({Algorithm algorithm, Function() afterConfiguration}) {
    _afterConfiguration = afterConfiguration;
    _worker = new Worker("worker/algorithm/workerScript.js");
    _worker.onMessage.listen((e) {
      _log(e.data);
      Transmission transmission = Transmission.fromTransmittable(e.data);
      if (transmission.typ == typ_movePlayed) {
        _s(transmission.object);
      } else if (transmission.typ == typ_initialised) {
        if (algorithm != null) {
          dynamic json =
              Transmission.configAlgorithm(algorithm).toTransmittable();
          _log(json);
          _worker.postMessage(json);
        }
      } else if (transmission.typ == typ_configured) {
        if (_afterConfiguration != null) {
          _afterConfiguration();
        }
      }
    });
  }

  @override
  playMove(GameState state, GameStateArgument s) {
    _s = s;
    _worker.postMessage(Transmission.playMove(state).toTransmittable());
  }

  @override
  terminate(GameState state, bool won) {}

  config(Algorithm algorithm, [void Function() startGame]) {
    dynamic json = Transmission.configAlgorithm(algorithm).toTransmittable();
    _log(json);
    _afterConfiguration = startGame;
    _worker.postMessage(json);
  }
}
