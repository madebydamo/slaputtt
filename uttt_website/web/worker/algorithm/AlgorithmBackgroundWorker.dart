@JS()
library sw;

import 'dart:html';

import 'package:js/js.dart';
import 'package:uttt_package/src/controller/algorithms/RandomMove.dart';
import 'package:uttt_package/src/model/Algorithm.dart';

import '../../transmission/Transmission.dart';

void _log(e) => print("Backend: $e");
//void _log(Object o) => {};

@JS("getMyGlobalScope")
external DedicatedWorkerGlobalScope getMyGlobalScope();

// Reminder: ServiceWorker mustn't use async in the [main] method.
void main() {
  DedicatedWorkerGlobalScope _self = getMyGlobalScope();
  _log('SW started.');
  Algorithm algorithm = RandomMove();
  _self.onMessage.listen((e) {
    _log(e.data);
    Transmission transmission = Transmission.fromTransmittable(e.data);
    if(transmission.typ == typ_playMove) {
      dynamic move = algorithm.getNextMove(transmission.object);
      _self.postMessage(Transmission.movePlayed(move).toTransmittable());
    } else if (transmission.typ == typ_configAlgorithm) {
      algorithm = transmission.object;
      _self.postMessage(Transmission.configured().toTransmittable());
    }
  });
  _self.postMessage(Transmission.initialised().toTransmittable());
}
