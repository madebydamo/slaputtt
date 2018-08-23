import 'package:uttt/src/model/GameState.dart';

class GameStateController {

  static List<BigTile> newGame() {

    List<BigTile> l = new List();
    for(int i = 0; i < 9; i++) {
      l.add(_newBigTile());
    }
    return l;
  }

  static BigTile _newBigTile() {
    List<Tile> l = new List();
    for(int i = 0; i < 9; i++) {
      l.add(new Tile());
    }
    return new BigTile(l);
  }
}