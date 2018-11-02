import 'dart:html';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/controller/GameStateController.dart' as GameController;
import 'package:uttt_package/src/model/Player.dart';
import 'package:uttt_package/src/controller/players/Computer.dart';
import 'package:uttt_package/src/controller/algorithms/RandomMove.dart';
import 'package:uttt_package/src/controller/Game.dart';

void main() {
  WebPlayer p1 = WebPlayer();
  Computer p2 = Computer(RandomMove());
  Game game = Game(p1, p2);
  game.start();
}

void visualize(GameState state) {
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
        querySelector(".bigTile$i > .tile$j").classes.add(playerCSS);
      }
    }
  }
}

class WebPlayer implements Player {
  GameState _state;
  GameStateArgument _s;

  WebPlayer() {
    for (int i = 0; i < 9; i++) {
      DivElement bigTile = new DivElement();
      bigTile.classes.add("bigTile$i");
      bigTile.classes.add("bigTile");
      for (int j = 0; j < 9; j++) {
        DivElement tile = new DivElement();
        tile.onClick.listen((event) {
          if (_state != null) {
            Move m = Move.ofIndex(State.p1, i, j);
            GameController.playMove(_state, m);
            visualize(_state);
            _s(_state);
          }
        });
        tile.classes.add("tile$j");
        tile.classes.add("tile");
        bigTile.children.add(tile);
      }
      querySelector("#tileWrapper").children.add(bigTile);
    }
  }

  @override
  playMove(GameState state, GameStateArgument s) {
    _state = state;
    _s = s;
    visualize(state);
  }
}
