@JS()
library sw;

import 'dart:html';
import 'package:js/js.dart';
import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';

import '../transmission/Transmission.dart';

void _log(e) => print("Backend: $e");
//void _log(Object o) => {};

@JS("getMyGlobalScope")
external DedicatedWorkerGlobalScope getMyGlobalScope();

// Reminder: ServiceWorker mustn't use async in the [main] method.
void main(List<String> args) {
  DedicatedWorkerGlobalScope _self = getMyGlobalScope();
  _log('SW started.');
  Algorithm algo;
  _self.onMessage.listen((e) {
    _log(e.data);
    Transmission transmission = Transmission.fromTransmittable(e.data);
    if(transmission.typ == typ_playMove) {
      dynamic state = algo.getNextMove(transmission.object);
      _self.postMessage(Transmission.movePlayed(state).toTransmittable());
    } else if (transmission.typ == typ_config) {
      _log("CONFIGURATED");
      algo = AlphaBetaPruning(3, HeuristicAlphaBeta(transmission.object));
    }
  });
  _self.postMessage(Transmission.initialised().toTransmittable());
}
