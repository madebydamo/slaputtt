import 'dart:html';
import 'package:uttt_package/src/model/Evolution.dart';
import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';

import '../controller/GameController.dart';

class LevelElement {
  
  static LevelElement _levelElement;
  Era _era;
  AnchorElement _easy, _medium, _hard;

  factory LevelElement(Era era) {
    if (_levelElement == null) {
      _levelElement = LevelElement._internal();
    }
    _levelElement.initialise(era);
    return _levelElement;
  }

  LevelElement._internal() {
   // <a class="waves-effect waves-teal btn-flat">Button</a>
    DivElement root = querySelector("#level");
    _easy = AnchorElement();
    _easy.innerHtml = "Easy";
    _easy.classes.addAll(["waves-effect", "waves-teal", "btn-flat"]);
    _easy.onClick.listen((e) {
      _onClickEasy();
    });


    _medium = AnchorElement();
    _medium.innerHtml = "Medium";
    _medium.classes.addAll(["waves-effect", "waves-teal", "btn-flat"]);
    _medium.onClick.listen((e) {
      _highlight(_medium);
      int index = _era.generations.length ~/ 2;
      GameController().config(AlphaBetaPruning(3, HeuristicAlphaBeta(_era.generations[index].best)), true);
    });

    _hard = AnchorElement();
    _hard.innerHtml = "Hard";
    _hard.classes.addAll(["waves-effect", "waves-teal", "btn-flat"]);
    _hard.onClick.listen((e) {
      _highlight(_hard);
      GameController().config(AlphaBetaPruning(3, HeuristicAlphaBeta(_era.lastTrainedGen.best)), true);
    });

    root.children.addAll([_easy, _medium, _hard]);
  }

  void _clear() {
    [_easy, _medium, _hard].forEach((a) => a.classes.remove("btn"));
    [_easy, _medium, _hard].forEach((a) => a.classes.add("btn-flat"));
  }

  void _highlight(AnchorElement a) {
    _clear();
    a.classes.remove("btn-flat");
    a.classes.add("btn");
  }

  void _onClickEasy() {
    _highlight(_easy);
    GameController().config(AlphaBetaPruning(3, HeuristicAlphaBeta(_era.generations.first.best)), true);
  }

  void initialise(Era era) {
    _era = era;
    _onClickEasy();
  }
}