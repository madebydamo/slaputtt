import 'dart:async';
import 'dart:html';
import 'dart:js';

import 'package:js/js.dart';
import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/model/Evolution.dart';
import 'package:uttt_package/src/model/GameState.dart';
import '../worker/game/GameSimulator.dart';
import 'Wrapper.dart';

class Compare {
  List<GameSimulator> _simulators;
  static Compare _compare;
  Completer _completer;
  Iterator<List<Algorithm>> _currentIterator;
  int _inEvaluation = 0;
  int _evaluated = 0;
  Wrapper _home;
  Wrapper _other;
  List<List<int>> _results;
  void Function(int fullSize, int done, int inProgress) _progress;
  bool _finished;

  Compare._() {
    Element compare = querySelector("#compare");
  }

  factory Compare() {
    if (_compare == null) _compare = Compare._();
    return _compare;
  }

  Future<void> compare(Wrapper home, Wrapper other,
      [void Function(int fullSize, int done, int inProgress)
          showProgress]) async {
    if (_completer == null || _completer.isCompleted) {
      _completer = Completer();
      _currentIterator = _getAllGames(home, other).iterator;
      _inEvaluation = 0;
      _evaluated = 0;
      _home = home;
      _other = other;
      _progress = showProgress;
      _results = List.generate(
          home.length(), (i) => List.generate(other.length(), (i) => 0),
          growable: false);
      _finished = false;
      if (_simulators == null) {
        int cores = window.navigator.hardwareConcurrency;
        _simulators = List.generate(cores > 2 ? cores - 2 : 1,
            (i) => GameSimulator(_next, _saveRating));
      } else {
        _simulators.forEach((s) => s.evaluateGame());
      }
    }
    return _completer.future.then((value) => {});
  }

  void _saveRating(State s, List<Algorithm> algorithms) {
    int idx1;
    int idx2;
    for (int i = 0; i < _home.length(); i++) {
      if (_home.getBest(i) ==
          ((algorithms[0] as AlphaBetaPruning).heuristic as HeuristicAlphaBeta)
              .dna) {
        idx1 = i;
        break;
      }
    }
    for (int i = 0; i < _other.length(); i++) {
      if (_other.getBest(i) ==
          ((algorithms[1] as AlphaBetaPruning).heuristic as HeuristicAlphaBeta)
              .dna) {
        idx2 = i;
        break;
      }
    }
    _results[idx1][idx2] = s == State.none
        ? 0
        : s == State.p1
            ? 1
            : 2;
    _evaluated++;
    if (_progress != null) {
      _progress(_home.length() * (_other.length()), _evaluated,
          _inEvaluation - _evaluated);
    }
    if (_finished && _evaluated == _inEvaluation) {
      _completer.complete();
    }
    showComparison(_results);
  }

  Iterable<List<Algorithm>> _getAllGames(Wrapper home, Wrapper other) sync* {
    for (int i = 0; i < home.length(); i++) {
      for (int j = 0; j < other.length(); j++) {
        DNA frist = home.getBest(i);
        DNA second = other.getBest(j);
        Algorithm algo1 = AlphaBetaPruning(2, HeuristicAlphaBeta(frist));
        Algorithm algo2 = AlphaBetaPruning(2, HeuristicAlphaBeta(second));
        yield [algo1, algo2];
      }
    }
  }

  List<Algorithm> _next() {
    if (_currentIterator.moveNext()) {
      _inEvaluation++;
      return _currentIterator.current;
    }
    _finished = true;
    return null;
  }
}

@JS()
external void showComparison(JsArray);
