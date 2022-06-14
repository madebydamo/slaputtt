library evolution;

import 'dart:async';
import 'dart:html';

import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/model/Evolution.dart';
import 'package:uttt_package/src/model/GameState.dart';

import '../worker/game/GameSimulator.dart';
import 'package:uttt_package/src/controller/evolution/EvolutionBase.dart';

class EvolutionWebController extends EvolutionBase {
  List<GameSimulator> _simulators;
  Iterator<List<Algorithm>> _currentIterator;
  Generation _currentGeneration;
  bool _finished = false;
  int _inEvaluation = 0;
  int _evaluated = 0;
  Completer _trainComplete;
  void Function(int fullSize, int done, int inProgress) _progress;

  EvolutionWebController() {}

  Future<void> train(Era era,
      [void Function(int fullSize, int done, int inProgress)
      showProgress]) async {
    if (_trainComplete == null || _trainComplete.isCompleted) {
      _trainComplete = Completer();
      _inEvaluation = 0;
      _evaluated = 0;
      _finished = false;
      _progress = showProgress;
      _currentGeneration = era.lastGen;
      _currentIterator = _getAllGames(era.depth).iterator;
      _trainGeneration(era.depth);
      era.currentState = trained;
    }
    return _trainComplete.future.then((d) => _currentGeneration.ratings.sort());
  }

  Iterable<List<Algorithm>> _getAllGames(int depth) sync* {
    for (int i = 0; i < _currentGeneration.ratings.length; i++) {
      for (int j = 0; j < _currentGeneration.ratings.length; j++) {
        if (i != j) {
          Rating rating1 = _currentGeneration.ratings[i];
          Rating rating2 = _currentGeneration.ratings[j];
          Algorithm algo1 =
          AlphaBetaPruning(depth, HeuristicAlphaBeta(rating1.dna));
          Algorithm algo2 =
          AlphaBetaPruning(depth, HeuristicAlphaBeta(rating2.dna));
          yield [algo1, algo2];
        }
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

  void _saveRating(State s, List<Algorithm> algorithms) {
    Rating rating1 = _currentGeneration.ratings.firstWhere((r) =>
    r.dna ==
        ((algorithms[0] as AlphaBetaPruning).heuristic as HeuristicAlphaBeta)
            .dna);
    Rating rating2 = _currentGeneration.ratings.firstWhere((r) =>
    r.dna ==
        ((algorithms[1] as AlphaBetaPruning).heuristic as HeuristicAlphaBeta)
            .dna);

    if (s == State.none) {
      rating1.stats.draws = rating1.stats.draws + 1;
      rating2.stats.draws = rating2.stats.draws + 1;
    } else if (s == State.p1) {
      rating1.stats.wins = rating1.stats.wins + 1;
      rating2.stats.loses = rating2.stats.loses + 1;
    } else if (s == State.p2) {
      rating1.stats.loses = rating1.stats.loses + 1;
      rating2.stats.wins = rating2.stats.wins + 1;
    }
    _evaluated++;
    if(_progress != null) {
      _progress(_currentGeneration.ratings.length *
          (_currentGeneration.ratings.length - 1),
          _evaluated,
          _inEvaluation - _evaluated);
    }
    if (_finished && _evaluated == _inEvaluation) {
      _trainComplete.complete();
    }
  }

  void _trainGeneration(int depth) {
    _currentGeneration.ratings.forEach((r) => r.stats = Stats());
    if (_simulators == null) {
      int cores = window.navigator.hardwareConcurrency;
      _simulators = List.generate(
          cores > 2 ? cores - 2 : 1, (i) => GameSimulator(_next, _saveRating));
    } else {
      _simulators.forEach((s) => s.evaluateGame());
    }
  }

  void trainAndMutate(Era era) {
    train(era);
    mutate(era);
  }
}
