import 'dart:convert';
import 'dart:html';

import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import 'package:uttt_package/src/model/Evolution.dart';

import 'components/evolution/Evolution.dart';
import 'controller/GameController.dart';

void main() {
  GameController controller = GameController();
  EvolutionElement element = EvolutionElement();
  HttpRequest.getString('17_3G70.json').then((jsonString) {
    Era era = Era.fromJson(json.decode(jsonString));
    element.setEra(era);
    controller.config(
        AlphaBetaPruning(3,HeuristicAlphaBeta(era.lastGen.best)),true);
  });
}
