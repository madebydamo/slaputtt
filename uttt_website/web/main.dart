import 'dart:html';

import 'package:uttt_package/src/controller/Game.dart';
import 'package:uttt_package/src/controller/GameStateController.dart'
    as GameController;
import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import 'package:uttt_package/src/controller/players/Computer.dart';
import 'package:uttt_package/src/model/Evolution.dart';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/model/Player.dart';

import 'components/Grid.dart';
import 'worker/AlphaBetaWorker.dart';

void main() {
  AlphaBetaWorker worker = AlphaBetaWorker(DNA(
      15.515486642969375,
      81.51786860231158,
      136.90917992046127,
      2139.7204623955636,
      13378.653412586225));
  WebPlayer p1 = WebPlayer();
//  Computer p2 = Computer(AlphaBetaPruning(
//      3, HeuristicAlphaBeta(DNA(17.512972423617676, 82.19404297705043, 108.1606648120098, 2188.1665543419103, 19116.077182562596))));
  Game game = Game(p1, worker);
  game.start();
}

class WebPlayer implements Player {
  GameState _state;
  GameStateArgument _s;
  GridElement _grid;


  WebPlayer() {
    _grid =  GridElement((event) {
      if (_state != null) {
        Move m = Move.ofIndex(State.p1, i, j);
        if (GameController.getAllPossibleMoves(_state).contains(m)) {
          GameController.playMove(_state, m);
          _grid.visualize(_state, false);
          _s(_state);
        }
      }
    });
  }



  @override
  playMove(GameState state, GameStateArgument s) {
    _state = state;
    _s = s;
    _grid.visualize(state);
  }

  @override
  terminate(GameState state, bool won) {
    print("Terminated, you have won: $won");
    querySelector("#winner").innerHtml = won ? "Congrats, you have won!" : "Maybe next time...";
    _grid.visualize(state);
  }
}
