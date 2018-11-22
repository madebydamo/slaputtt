import 'dart:html';
import 'package:uttt_package/src/model/GameState.dart';

typedef void MouseEventHandler(MouseEvent e, int big, int small);

class GridElement extends DivElement {

  static final List<String> tilePositionHorizontal = [
    "top",
    "top",
    "top",
    "middle",
    "middle",
    "middle",
    "bottom",
    "bottom",
    "bottom"
  ];
  static final List<String> tilePositionVertical = [
    "left",
    "center",
    "right",
    "left",
    "center",
    "right",
    "left",
    "center",
    "right"
  ];

  GridElement(MouseEventHandler handler) : super.created() {
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
        tile.onClick.listen(handler(e, i, j));
        tile.classes.add("tile$j");
        tile.classes.add("tile");
        tileHolder.children.add(tile);
        tile.classes.add(tilePositionHorizontal[j]);
        tile.classes.add(tilePositionVertical[j]);
      }
      querySelector("#tileWrapper").children.add(bigTile);
    }
  }

  void visualize(GameState state, [bool possibleMoves = true]) {
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
    if(!GameController.isGameFinished(state)) {
      querySelectorAll(".flip-in-hor-bottom")
          .forEach((e) => e.classes.remove("flip-in-hor-bottom"));
      if (state.lastMove != Move.init) {
        querySelector(
            ".bigTile${state.lastMove.bigIndex} .tile${state.lastMove
                .smallIndex}")
            .classes
            .add("flip-in-hor-bottom");
      }
    }
  }

  void _visualizePossibleMoves(bool possibleMoves, GameState state) {
    querySelectorAll(".yellow").forEach((e) => e.classes.remove("yellow"));
    if (possibleMoves) {
      GameController.getAllPossibleMoves(state).forEach((m) {
        querySelector(".bigTile${m.bigIndex} .tile${m.smallIndex}")
            .classes
            .add("yellow");
      });
    }
  }

}