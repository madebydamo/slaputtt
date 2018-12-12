import 'dart:convert';
import 'dart:html';

import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import 'package:uttt_package/src/model/Evolution.dart';

import 'components/Evolution.dart';
import 'controller/GameController.dart';

void main() {
  GameController controller = GameController();
  controller.config(
      AlphaBetaPruning(
          3,
          HeuristicAlphaBeta(DNA(15.515486642969375, 81.51786860231158,
              136.90917992046127, 2139.7204623955636, 13378.653412586225))),
      true);

  EvolutionElement element = EvolutionElement();
  HttpRequest.getString('era2.json').then((jsonString) {
    Era era = Era.fromJson(json.decode(jsonString));
    element.setEra(era);
  });
}
