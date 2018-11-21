import 'dart:html';

import 'package:uttt_package/src/controller/Game.dart';
import 'package:uttt_package/src/controller/GameStateController.dart' as GameController;
import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import 'package:uttt_package/src/controller/players/Computer.dart';
import 'package:uttt_package/src/model/Evolution.dart';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/model/Player.dart';
import 'package:uttt_package/src/controller/algorithms/RandomMove.dart';

void main() {
  Worker worker = new Worker("worker/workerScript.js");
  worker.onMessage.listen((e) => print(e.data));
  WebPlayer p1 = WebPlayer();
//  Computer p2 = Computer(AlphaBetaPruning(
//      3, HeuristicAlphaBeta(DNA(17.512972423617676, 82.19404297705043, 108.1606648120098, 2188.1665543419103, 19116.077182562596))));
  Player p2 = Computer(RandomMove());
  Game game = Game(p1, p2);
  game.start();
}

class WebPlayer implements Player {
  GameState _state;
  GameStateArgument _s;
  static final List<String> tilePositionHorizontal =  ["top", "top", "top", "middle", "middle", "middle", "bottom", "bottom", "bottom"];
  static final List<String> tilePositionVertical = ["left", "center", "right", "left", "center", "right", "left", "center", "right"];

  WebPlayer() {
    for (int i = 0; i < 9; i++) {
      DivElement bigTile = new DivElement();
      DivElement tileHolder = new DivElement();
      bigTile.children.add(tileHolder);
      tileHolder.classes.add("wrapper");
      tileHolder.classes.add("grid-container");
      bigTile.classes.add("bigTile$i");
      bigTile.classes.add("bigTile");
      bigTile.classes.add(tilePositionHorizontal[i]);
      bigTile.classes.add(tilePositionVertical[i]);
      for (int j = 0; j < 9; j++) {
        DivElement tile = new DivElement();
        tile.onClick.listen((event) {
          if (_state != null) {
            Move m = Move.ofIndex(State.p1, i, j);
            if (GameController.getAllPossibleMoves(_state).contains(m)) {
              GameController.playMove(_state, m);
              _visualize(_state, false);
              _s(_state);
            }
          }
        });
        tile.classes.add("tile$j");
        tile.classes.add("tile");
        tileHolder.children.add(tile);
        tile.classes.add(tilePositionHorizontal[j]);
        tile.classes.add(tilePositionVertical[j]);
      }
      querySelector("#tileWrapper").children.add(bigTile);
    }
  }

  void _visualize(GameState state, [bool possibleMoves = true]) {
    for (int i = 0; i < 9; i++) {
      BigTile bigTile = state.tiles[i];
      String playerCSS;
      if (bigTile.state == State.p1) playerCSS = "p1BigTile";
      if (bigTile.state == State.p2) playerCSS = "p2BigTile";
      if (playerCSS != null) {
        querySelector(".bigTile$i").classes.add(playerCSS);
      }

      for (int j = 0; j < 9; j++) {
        playerCSS = null;
        Tile tile = bigTile.tiles[j];
        if (tile.state == State.p1) playerCSS = "p1SmallTile";
        if (tile.state == State.p2) playerCSS = "p2SmallTile";
        if (playerCSS != null) {
          querySelector(".bigTile$i .tile$j").classes.add(playerCSS);
        }
      }
    }
    _visualizeLastPlayedMove(state);
    _visualizePossibleMoves(possibleMoves, state);
  }

  void _visualizeLastPlayedMove(GameState state) {
    querySelectorAll(".swing-in-top-fwd").forEach((e) => e.classes.remove("swing-in-top-fwd"));
    if (state.lastMove != Move.init) {
      querySelector(
          ".bigTile${state.lastMove.bigIndex} .tile${state.lastMove
              .smallIndex}")
          .classes.add("swing-in-top-fwd");
    }
  }

  void _visualizePossibleMoves(bool possibleMoves, GameState state) {
    querySelectorAll(".yellow").forEach((e) => e.classes.remove("yellow"));
    if(possibleMoves) {
      GameController.getAllPossibleMoves(state).forEach((m) {
        querySelector(".bigTile${m.bigIndex} .tile${m.smallIndex}")
            .classes.add("yellow");
      });
    }
  }

  @override
  playMove(GameState state, GameStateArgument s) {
    _state = state;
    _s = s;
    _visualize(state);
  }

  @override
  terminate(GameState state, bool won) {
    _visualize(state);

  }
}
