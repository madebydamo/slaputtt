import 'dart:async';
import 'dart:html';

import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/model/Player.dart';
import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';

import '../../components/Opponent.dart';
import '../../transmission/Transmission.dart';

void _log(e) => print("Frontend: $e");

class AlgorithmWorker implements Player {
  Worker _worker;
  Completer<Move> _completer;
  void Function() _afterConfiguration;
  OpponentElement _opponentElement;

  AlgorithmWorker({Algorithm algorithm, Function() afterConfiguration}) {
    _opponentElement = OpponentElement();
    _worker = new Worker("worker/algorithm/workerScript.js");
    _worker.onMessage.listen((e) {
      _log(e.data);
      Transmission transmission = Transmission.fromTransmittable(e.data);
      if (transmission.typ == typ_movePlayed) {
        _completer.complete(transmission.object);
      } else if (transmission.typ == typ_initialised) {
        if (algorithm != null) {
          config(algorithm, afterConfiguration);
        }
      } else if (transmission.typ == typ_configured) {
        if (_afterConfiguration != null) {
          _afterConfiguration();
          _afterConfiguration = null;
        }
      }
    });
  }

  @override
  Future<Move> playMove(GameState state) {
    _completer = Completer();
    _worker.postMessage(Transmission.playMove(state).toTransmittable());
    return _completer.future;
  }

  @override
  terminate(GameState state, bool won) {}

  config(Algorithm algorithm, [void Function() startGame]) {
    dynamic json = Transmission.configAlgorithm(algorithm).toTransmittable();
    if (algorithm is AlphaBetaPruning) {
      _opponentElement
          .initialise((algorithm.heuristic as HeuristicAlphaBeta).dna);
    }
    _log(json);
    _afterConfiguration = startGame ?? _afterConfiguration;
    _worker.postMessage(json);
  }
}
