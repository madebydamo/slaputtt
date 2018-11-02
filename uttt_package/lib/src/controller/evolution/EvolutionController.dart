import 'package:uttt_package/src/controller/Game.dart';
import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import 'package:uttt_package/src/controller/players/Computer.dart';
import 'package:uttt_package/src/model/Evolution.dart';
import 'dart:math';

import 'package:uttt_package/src/model/Player.dart';

Era initialiseEra(int size, depth) {
  Era era = Era();
  Generation gen1 = Generation(List.generate(size, (i) => _randomDNA()));
  era.generations.add(gen1);
  //TODO abfüllen
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

void trainGeneration(Era era) {
  Generation generation = era.generations[era.generations.length];
  List<Stats> stats = List.generate(generation.organism.length, (i) => Stats());
  for (int i = 0; i < generation.organism.length; i++) {
    for (int j = i + 1; j < generation.organism.length; i++) {
      DNA dna1 = generation.organism[i];
      DNA dna2 = generation.organism[j];
      Player p1 = Computer(AlphaBetaPruning(era.depth, HeuristicAlphaBeta(dna1)));
      Player p2 = Computer(AlphaBetaPruning(era.depth, HeuristicAlphaBeta(dna2)));
      Game game = Game(p1, p2);
      game.start();
      if (game.winner == null) {
        stats[i].draws = stats[i].draws + 1;
        stats[j].draws = stats[j].draws + 1;
      } else if(game.winner == p1) {
        stats[i].wins = stats[i].wins + 1;
        stats[j].loses = stats[j].loses + 1;
      } else if(game.winner == p2) {
        stats[i].loses = stats[i].loses + 1;
        stats[j].wins = stats[j].wins + 1;
      }
    }
  }
  List<Stats> origin = List.from(stats);
  stats.sort((s1, s2) => s1.value > s2.value ? 1 : s1.value == s2.value ? 0 : -1);
  stats.forEach((s) {
    generation.order[origin.indexOf(s)]
  });
}

class Stats {
  int wins;
  int draws;
  int loses;

  State() {
    wins = 0;
    draws = 0;
    loses = 0;
  }

  get value => wins * 3 + draws;
}
