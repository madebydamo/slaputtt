import 'dart:html';

import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/model/Player.dart';

import '../../transmission/Transmission.dart';

void _log(e) => print("Frontend: $e");

class AlphaBetaWorker implements Player {
  Worker _worker;
  GameStateArgument _s;

  AlphaBetaWorker(Algorithm algorithm) {
    _worker = new Worker("worker/algorithm/workerScript.js");
    _worker.onMessage.listen((e) {
      _log(e.data);
      Transmission transmission = Transmission.fromTransmittable(e.data);
      if(transmission.typ == typ_movePlayed) {
        _s(transmission.object);
      } else if (transmission.typ == typ_initialised) {
        dynamic json = Transmission.configAlgorithm(algorithm)
            .toTransmittable();
        _log(json);
        _worker.postMessage(json);
      }
    });
  }

  @override
  playMove(GameState state, GameStateArgument s) {
    _s = s;
    _worker.postMessage(Transmission.playMove(state).toTransmittable());
  }

  @override
  terminate(GameState state, bool won) {
    _worker.terminate();
  }

}
