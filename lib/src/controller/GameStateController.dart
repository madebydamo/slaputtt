import 'package:uttt/src/model/GameState.dart';

class GameStateController {
  static List<BigTile> newGame() {
    List<BigTile> l = new List();
    for (int i = 0; i < 9; i++) {
      l.add(_newBigTile());
    }
    return l;
  }

  static BigTile _newBigTile() {
    List<Tile> l = new List();
    for (int i = 0; i < 9; i++) {
      l.add(new Tile());
    }
    return new BigTile(l);
  }

  static void visualize(GameState state) {
    String s = "";
    for (int i = 0; i < 132; i++) {
      int row = i ~/ 12;
      int column = i % 12;
      if (column == 11) {
        s += "\n";
        continue;
      }
      if ((column + 1) % 4 == 0) {
        s += " ";
        continue;
      }
      if ((row + 1) % 4 == 0) {
        s += " ";
        continue;
      }
      int subrow = (row - row ~/ 4) ~/ 3;
      int subcolumn = (column - column ~/ 4) ~/ 3;
      int subsubrow = (row - row ~/ 4) % 3;
      int subsubcolumn = (column - column ~/ 4) % 3;
      //print((subrow * 3 + subcolumn).toString() + ":" + (subsubrow * 3 + subsubcolumn).toString());
      s += (state.tiles.elementAt(subrow * 3 + subcolumn) as BigTile)
          .tiles
          .elementAt(subsubrow * 3 + subsubcolumn)
          .state
          .toString();
    }
    print(s);
  }

  static bool isGameFinished(GameState state) {
    //TODO implement
    return false;
  }

  static double evaluateValue(GameState state) {
    //TODO implement
    return 0.0;
  }

  static List<Move> getAllPossibleMoves(GameState state) {
    //TODO implement
    return new List<Move>();
  }

  static GameState playMove(GameState state, Move move) {
    //TODO implement
    return new GameState();
  }
}
