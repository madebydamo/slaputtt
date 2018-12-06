@JS()
library sw;

import 'dart:html';

import 'package:js/js.dart';
import 'package:uttt_package/src/controller/Game.dart';
import 'package:uttt_package/src/controller/players/Computer.dart';

import '../../transmission/Transmission.dart';

void _log(e) => print("Backend GameSimulator: $e");
//void _log(Object o) => {};

@JS("getMyGlobalScope")
external DedicatedWorkerGlobalScope getMyGlobalScope();

// Reminder: ServiceWorker mustn't use async in the [main] method.
void main() {
  DedicatedWorkerGlobalScope _self = getMyGlobalScope();
  _log('SW started.');
  _self.onMessage.listen((e) {
    _log(e.data);
    Transmission transmission = Transmission.fromTransmittable(e.data);
    if (transmission.typ == typ_playGame) {
      Game game = Game(Computer(transmission.object[0]), Computer(transmission.object[1]), (s) {
        _self.postMessage(Transmission.gameWinner(s));
      });
      game.start();
    }
  });
  _self.postMessage(Transmission.initialised().toTransmittable());
}
