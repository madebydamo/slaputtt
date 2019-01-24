library evolution;

import 'dart:math';

import 'package:uttt_package/src/controller/Game.dart';
import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import 'package:uttt_package/src/controller/players/Computer.dart';
import 'package:uttt_package/src/model/Evolution.dart';
import 'package:uttt_package/src/model/Player.dart';

part 'package:uttt_package/src/controller/evolution/EvolutionBase.dart';

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

