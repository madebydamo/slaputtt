import 'package:uttt/src/model/GameState.dart';

main() {
  var gs = new GameState();
  (gs.tiles.elementAt(0) as Grid).tiles.elementAt(0).state = State.p1;
  (gs.tiles.elementAt(0) as Grid).tiles.elementAt(4).state = State.p1;
  (gs.tiles.elementAt(0) as Grid).tiles.elementAt(8).state = State.p1;
  (gs.tiles.elementAt(2) as Grid).tiles.elementAt(2).state = State.p1;
  (gs.tiles.elementAt(3) as Grid).tiles.elementAt(3).state = State.p1;
  (gs.tiles.elementAt(4) as Grid).tiles.elementAt(4).state = State.p1;
  (gs.tiles.elementAt(8) as Grid).tiles.elementAt(8).state = State.p1;
  print(gs);
}