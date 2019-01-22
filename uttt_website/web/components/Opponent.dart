import 'dart:html';

import 'package:uttt_package/src/model/Evolution.dart';

import '../controller/GameController.dart';
import '../materializecss/range/Range.dart';
import 'evolution/Rating.dart';
import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';

class OpponentElement {
  static OpponentElement _opponentElement;

  DivElement _ratingParent;
  DNA _dna;

  factory OpponentElement({DNA dna}) {
    if (_opponentElement == null) {
      _opponentElement = OpponentElement._internal();
    }
    if (dna != null) _opponentElement.initialise(dna);
    return _opponentElement;
  }

  OpponentElement._internal() {
    DivElement root = querySelector("#opponent");
    _ratingParent = DivElement();
    if(root != null) {
      ParagraphElement searchDepthPara = ParagraphElement();
      searchDepthPara.innerHtml = "Depth of search of the current opponent";
      ParagraphElement depthWrapper = ParagraphElement();
      depthWrapper.classes.add("range-field");
      InputElement depth = InputElement(type: "range");
      depth.max = "7";
      depth.min = "1";
      depth.value = "3";
      depth.step = "1";
      depth.onChange.listen((e) => GameController().config(
          AlphaBetaPruning(int.tryParse(depth.value), HeuristicAlphaBeta(_dna))));
      depthWrapper.children.add(depth);
      root.children.addAll([_ratingParent, searchDepthPara, depthWrapper]);
      initRange(depth);
    }
  }

  void initialise(DNA dna) {
    _dna = dna;
    _ratingParent.children.clear();
    DNAChart(_ratingParent, dna);
  }
}
