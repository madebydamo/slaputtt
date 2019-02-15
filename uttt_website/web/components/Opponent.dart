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
  bool _visible;
  InputElement _depth;

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
    _visible = root != null;
    if(_visible) {
      ParagraphElement searchDepthPara = ParagraphElement();
      searchDepthPara.innerHtml = "Depth of search of the current opponent";
      ParagraphElement depthWrapper = ParagraphElement();
      depthWrapper.classes.add("range-field");
      _depth = InputElement(type: "range");
      _depth.max = "7";
      _depth.min = "1";
      _depth.value = "3";
      _depth.step = "1";
      _depth.onChange.listen((e) => GameController().config(
          AlphaBetaPruning(int.tryParse(_depth.value), HeuristicAlphaBeta(_dna))));
      depthWrapper.children.add(_depth);
      root.children.addAll([_ratingParent, searchDepthPara, depthWrapper]);
      initRange(_depth);
    }
  }

  int get searchDepth => _visible ? int.tryParse(_depth.value) : 3;

  void initialise(DNA dna) {
    _dna = dna;
    _ratingParent.children.clear();
    DNAChart(_ratingParent, dna);
  }
}
