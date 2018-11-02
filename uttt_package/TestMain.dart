import 'package:uttt_package/src/controller/algorithms/RandomMove.dart';
import 'package:uttt_package/src/controller/players/Computer.dart';
import 'package:uttt_package/src/controller/Game.dart';
import 'package:uttt_package/src/model/Player.dart';

main() {
  Player p1 = Computer(RandomMove());
  Player p2 = Computer(RandomMove());
  Game game = Game(p1, p2);
  game.start();
}