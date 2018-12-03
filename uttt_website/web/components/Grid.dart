import 'dart:html';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/controller/GameStateController.dart' as GC;

typedef void MouseEventHandler(MouseEvent e, int bigIndex, int smallIndex);

class GridElement {
  static GridElement _gridElement;

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

  factory GridElement(MouseEventHandler handler) {
    if (_gridElement == null) {
      _gridElement = GridElement._internal(handler);
    }
    _gridElement.clear();
    return _gridElement;
  }

  GridElement._internal(MouseEventHandler handler) {
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
        tile.onClick.listen((e) => handler(e, i, j));
        tile.classes.add("tile$j");
        tile.classes.add("tile");
        tileHolder.children.add(tile);
        tile.classes.add(tilePositionHorizontal[j]);
        tile.classes.add(tilePositionVertical[j]);
      }
      querySelector("#tileWrapper").children.add(bigTile);
    }
    querySelector("#tileWrapper").classes.add("flip-in-hor-bottom-big");
  }

  void visualize(GameState state, [bool possibleMoves = true]) {
    clear();
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

  void clear() {
    _clearClass("p1BigTile");
    _clearClass("p2BigTile");
    _clearClass("p1SmallTile");
    _clearClass("p2SmallTile");
    _clearClass("flip-in-hor-bottom");
    _clearClass("yellow");
  }

  void _visualizeLastPlayedMove(GameState state) {
    _clearClass("flip-in-hor-bottom");
    if (!GC.isGameFinished(state)) {
      if (state.lastMove != Move.init) {
        querySelector(
                ".bigTile${state.lastMove.bigIndex} .tile${state.lastMove.smallIndex}")
            .classes
            .add("flip-in-hor-bottom");
      }
    }
  }

  void _visualizePossibleMoves(bool possibleMoves, GameState state) {
    _clearClass("yellow");
    if (possibleMoves) {
      GC.getAllPossibleMoves(state).forEach((m) {
        querySelector(".bigTile${m.bigIndex} .tile${m.smallIndex}")
            .classes
            .add("yellow");
      });
    }
  }

  void _clearClass(String classname) {
    querySelectorAll(".$classname")
        .forEach((e) => e.classes.remove(classname));
  }
}
