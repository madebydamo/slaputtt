import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/model/Player.dart';
import 'package:uttt_package/src/model/Evolution.dart';
import 'dart:html';

import '../transmission/Transmission.dart';

void _log(e) => print("Frontend: $e");

class AlphaBetaWorker implements Player {

  Worker _worker;
  GameStateArgument _s;
  AlphaBetaWorker(DNA dna) {
    _worker = new Worker("worker/workerScript.js");
    _worker.onMessage.listen((e) {
      _log(e.data);
      Transmission transmission = Transmission.fromTransmittable(e.data);
      if(transmission.typ == typ_movePlayed) {
        _s(transmission.object);
      } else if (transmission.typ == typ_initialised) {
        dynamic json = Transmission.config(dna).toTransmittable();
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
