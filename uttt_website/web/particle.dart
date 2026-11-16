import 'dart:convert';
import 'dart:html';

import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import 'package:uttt_package/src/model/Evolution.dart';

import 'components/BrowserInfo.dart';
import 'components/Navbar.dart';
import 'components/Telemetry.dart';
// Dont ask me why Evolution.dart is not working...
import 'components/particle/ParticleEvolution.dart';
import 'controller/GameController.dart';

void main() {
  trackErrors();
  Navbar();
  BrowserInfo();
  GameController controller = GameController()..ai = 'pso';
  ParticleEvolutionElement element = ParticleEvolutionElement();
  HttpRequest.getString('16_2G20P.json').then((jsonString) {
    ParticleEra era = ParticleEra.fromJson(json.decode(jsonString));
    element.setEra(era);
    controller.config(
        AlphaBetaPruning(3, HeuristicAlphaBeta(era.lastGen.best)), true);
    track('era/pso/ok');
  }).catchError((e) {
    track('era/pso/error');
    trackError('era');
    window.console.error('Loading the opponents failed: $e');
  });
}
