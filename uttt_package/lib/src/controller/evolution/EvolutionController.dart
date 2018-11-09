import 'dart:math';

import 'package:uttt_package/src/controller/Game.dart';
import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import 'package:uttt_package/src/controller/players/Computer.dart';
import 'package:uttt_package/src/model/Evolution.dart';
import 'package:uttt_package/src/model/Player.dart';

Era initialiseEra(int size, depth) {
  Era era = Era(depth);
  Generation gen1 = Generation(
      List.generate(size, (i) => Rating(_randomDNA())));
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
  Generation generation = era.lastGen;
  _trainGeneration(generation, era.depth);
  era.currentState = trained;
}

void _trainGeneration(Generation generation, int depth) {
  generation.ratings.forEach((r) => r.stats = Stats());
  for (int i = 0; i < generation.ratings.length; i++) {
    for (int j = i + 1; j < generation.ratings.length; j++) {
      Rating rating1 = generation.ratings[i];
      Rating rating2 = generation.ratings[j];
      Player p1 = Computer(
          AlphaBetaPruning(depth, HeuristicAlphaBeta(rating1.dna)));
      Player p2 = Computer(
          AlphaBetaPruning(depth, HeuristicAlphaBeta(rating2.dna)));
      Game game = Game(p1, p2);
      game.start();
      if (game.winner == null) {
        rating1.stats.draws = rating1.stats.draws + 1;
        rating2.stats.draws = rating2.stats.draws + 1;
      } else if(game.winner == p1) {
        rating1.stats.wins = rating1.stats.wins + 1;
        rating2.stats.loses = rating2.stats.loses + 1;
      } else if(game.winner == p2) {
        rating1.stats.loses = rating1.stats.loses + 1;
        rating2.stats.wins = rating2.stats.wins + 1;
      }
    }
  }
}

void trainAndMutate(Era era) {
  train(era);
  mutate(era);
}

void mutate(Era era) {
  assert(era.currentState == trained, "You have to train your generation first!");
  Generation generation = era.lastTrainedGen;
  era.generations.add(_mutateGeneration(generation));
  era.currentState = mutated;
}

Generation _mutateGeneration(Generation generation) {
  List<Rating> list = [];
  generation.ratings.sort();
  if (generation.ratings.length.isEven) {
    for (int i = generation.ratings.length ~/ 2 + 1; i <
        generation.ratings.length; i++) {
      list.add(Rating(_mutateDNA(generation.ratings[i].dna)));
      list.add(Rating(_mutateDNA(generation.ratings[i].dna)));
    }
    list.add(Rating(
        _mutateDNA(generation.ratings[generation.ratings.length ~/ 2].dna)));
    list.add(Rating(generation.ratings[generation.ratings.length - 1].dna));
  } else {
    for (int i = (generation.ratings.length + 1) ~/ 2; i <
        generation.ratings.length; i++) {
      list.add(Rating(_mutateDNA(generation.ratings[i].dna)));
      list.add(Rating(_mutateDNA(generation.ratings[i].dna)));
    }
    list.add(Rating(generation.ratings[generation.ratings.length - 1].dna));
  }
  assert(list.length == generation.ratings
      .length, "Old generation and mutated generation doesn't have the same size");
  return Generation(list);
}

DNA _mutateDNA(DNA dna) {
  return DNA(_mutateNumber(dna.smallOne), _mutateNumber(dna.smallTwo),
      _mutateNumber(dna.bigOne), _mutateNumber(dna.bigTwo),
      _mutateNumber(dna.bigThree));
}

double _mutateNumber(double d) {
  Random r = Random();
  return d * (r.nextDouble() * 0.4 + 0.8);
}

