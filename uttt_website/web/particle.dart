import 'dart:convert';
import 'dart:html';

import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import 'package:uttt_package/src/model/Evolution.dart';

import 'components/BrowserInfo.dart';
import 'components/Navbar.dart';
// Dont ask me why Evolution.dart is not working...
import 'components/particle/ParticleEvolution.dart';
import 'controller/GameController.dart';

void main() {
  Navbar();
  BrowserInfo();
  GameController controller = GameController();
  ParticleEvolutionElement element = ParticleEvolutionElement();
  HttpRequest.getString('16_2G20P.json').then((jsonString) {
    ParticleEra era = ParticleEra.fromJson(json.decode(jsonString));
    element.setEra(era);
    controller.config(
        AlphaBetaPruning(3, HeuristicAlphaBeta(era.lastGen.best)), true);
  });
}
