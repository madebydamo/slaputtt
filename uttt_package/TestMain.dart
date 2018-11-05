import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/algorithms/RandomMove.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import 'package:uttt_package/src/controller/players/Computer.dart';
import 'package:uttt_package/src/controller/Game.dart';
import 'package:uttt_package/src/model/Evolution.dart';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/model/Player.dart';

main() {
  Player p1 = Computer(RandomMove());
  Player p2 = Computer(AlphaBetaPruning(5, HeuristicAlphaBeta(DNA(1.0, 4.0, 20.0, 80.0, 500.0))));
  // Player p2 = Computer(RandomMove());
  List<State> winners = [];
  for(int i = 0; i < 20; i++) {
    Game game = Game(p1, p2);
    game.start();
    if(game.winner == null) winners.add(State.none);
    if(game.winner == p1) winners.add(State.p1);
    if(game.winner == p2) winners.add(State.p2);
  }
  winners.forEach((s) => print(s));
}