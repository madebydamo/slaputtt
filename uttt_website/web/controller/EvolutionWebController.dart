import 'dart:html';
import 'dart:math';

import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/model/Evolution.dart';
import 'package:uttt_package/src/model/GameState.dart';

import '../worker/game/GameSimulator.dart';

bool _inTraining;
List<GameSimulator> _simulators;
Iterator<List<Algorithm>> _currentIterator;
Generation _currentGeneration;
bool _finished;
int _inEvaluation;
int _evaluated;

Era initialiseEra(int size, depth) {
  Era era = Era(depth);
  Generation gen1 =
      Generation(List.generate(size, (i) => Rating(_randomDNA())));
  era.generations.add(gen1);
  return era;
}

DNA _randomDNA() {
  Random r = Random();
  double smallOne = r.nextDouble() * 2000;
  double smallTwo = r.nextDouble() * 2000;
  double bigOne = r.nextDouble() * 2000;
  double bigTwo = r.nextDouble() * 2000;
  double bigThree = r.nextDouble() * 2000;

  return DNA(smallOne, smallTwo, bigOne, bigTwo, bigThree);
}

void train(Era era) {
  if (!_inTraining) {
    _inTraining = true;
    _inEvaluation = 0;
    _evaluated = 0;
    _finished = false;
    _currentGeneration = era.lastGen;
    _currentIterator = _getAllGames().iterator;
    _trainGeneration(era.depth);
    era.currentState = trained;
  }
}

Iterable<List<Algorithm>> _getAllGames() sync* {
  for (int i = 0; i < _currentGeneration.ratings.length; i++) {
    for (int j = 0; j < _currentGeneration.ratings.length; j++) {
      if (i != j) {
        Rating rating1 = _currentGeneration.ratings[i];
        Rating rating2 = _currentGeneration.ratings[j];
        Algorithm algo1 = AlphaBetaPruning(3, HeuristicAlphaBeta(rating1.dna));
        Algorithm algo2 = AlphaBetaPruning(3, HeuristicAlphaBeta(rating2.dna));
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
  if (_finished && _evaluated == _inEvaluation) {
    _inTraining = false;
  }
}

void _trainGeneration(int depth) {
  _currentGeneration.ratings.forEach((r) => r.stats = Stats());
  if (_simulators == null) {
    int cores = window.navigator.hardwareConcurrency;
    List.generate(
        cores > 2 ? cores - 2 : 1, (i) => GameSimulator(_next, _saveRating));
  } else {
    _simulators.forEach((s) => s.evaluateGame());
  }
}

void trainAndMutate(Era era) {
  train(era);
  mutate(era);
}

void mutate(Era era) {
  assert(
      era.currentState == trained, "You have to train your generation first!");
  Generation generation = era.lastTrainedGen;
  era.generations.add(_mutateGeneration(generation));
  era.currentState = mutated;
}

Generation _mutateGeneration(Generation generation) {
  List<Rating> list = [];
  generation.ratings.sort();
  if (generation.ratings.length.isEven) {
    for (int i = generation.ratings.length ~/ 2 + 1;
        i < generation.ratings.length;
        i++) {
      list.add(Rating(_mutateDNA(generation.ratings[i].dna)));
      list.add(Rating(_mutateDNA(generation.ratings[i].dna)));
    }
    list.add(Rating(
        _mutateDNA(generation.ratings[generation.ratings.length ~/ 2].dna)));
    list.add(Rating(generation.ratings[generation.ratings.length - 1].dna));
  } else {
    for (int i = (generation.ratings.length + 1) ~/ 2;
        i < generation.ratings.length;
        i++) {
      list.add(Rating(_mutateDNA(generation.ratings[i].dna)));
      list.add(Rating(_mutateDNA(generation.ratings[i].dna)));
    }
    list.add(Rating(generation.ratings[generation.ratings.length - 1].dna));
  }
  assert(list.length == generation.ratings.length,
      "Old generation and mutated generation doesn't have the same size");
  return Generation(list);
}

DNA _mutateDNA(DNA dna) {
  return DNA(
      _mutateNumber(dna.smallOne),
      _mutateNumber(dna.smallTwo),
      _mutateNumber(dna.bigOne),
      _mutateNumber(dna.bigTwo),
      _mutateNumber(dna.bigThree));
}

double _mutateNumber(double d) {
  Random r = Random();
  return d * (r.nextDouble() * 0.4 + 0.8);
}
