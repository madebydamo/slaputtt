import 'package:uttt_package/src/controller/evolution/EvolutionController.dart';
import 'package:uttt_package/src/model/Evolution.dart';

main() {
//  Player p1 = Computer(RandomMove());
//  Player p2 = Computer(AlphaBetaPruning(5, HeuristicAlphaBeta(DNA(1.0, 4.0, 20.0, 80.0, 500.0))));
//  // Player p2 = Computer(RandomMove());
//  List<State> winners = [];
//  for(int i = 0; i < 20; i++) {
//    Game game = Game(p1, p2);
//    game.start();
//    if(game.winner == null) winners.add(State.none);
//    if(game.winner == p1) winners.add(State.p1);
//    if(game.winner == p2) winners.add(State.p2);
//  }
//  winners.forEach((s) => print(s));

  Era era = initialiseEra(20, 3);
  do {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    trainAndMutate(era);
    print("Gen: ${era.generations.length - 1}, Time = ${(new DateTime.now().millisecondsSinceEpoch - startTime) / 1000}");
    DNA dna = era.lastTrainedGen.best;
    print("DNA: ${dna.smallOne} ; ${dna.smallTwo} ; ${dna.bigOne} ; ${dna
        .bigTwo} ; ${dna.bigThree}");
  } while (era.generations.length < 500);
}