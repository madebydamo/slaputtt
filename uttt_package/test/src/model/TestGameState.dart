import 'dart:convert';

import 'package:test/test.dart';
import 'package:uttt_package/src/model/GameState.dart';

void main() {
  group("GameState", () {
    test("new", () {
      GameState state1 = GameState();
      GameState state2 = GameState();
      expect(state1, state2);
    });
    test("from Json", () {
      GameState state1 = GameState.fromJson(json.decode('{"tiles":[{"tiles":[{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"X"}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}}],"state":{"state":"."}},{"tiles":[{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}}],"state":{"state":"."}},{"tiles":[{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"O"}},{"state":{"state":"."}},{"state":{"state":"O"}},{"state":{"state":"."}},{"state":{"state":"O"}},{"state":{"state":"."}},{"state":{"state":"X"}}],"state":{"state":"O"}},{"tiles":[{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}}],"state":{"state":"."}},{"tiles":[{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"X"}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"X"}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"X"}}],"state":{"state":"X"}},{"tiles":[{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"O"}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"O"}},{"state":{"state":"."}}],"state":{"state":"."}},{"tiles":[{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"X"}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}}],"state":{"state":"."}},{"tiles":[{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"X"}}],"state":{"state":"."}},{"tiles":[{"state":{"state":"O"}},{"state":{"state":"."}},{"state":{"state":"X"}},{"state":{"state":"."}},{"state":{"state":"O"}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"."}},{"state":{"state":"O"}}],"state":{"state":"O"}}],"lastMove":{"state":{"state":"O"},"xBigTile":2,"yBigTile":2,"xTile":0,"yTile":0}}'));
      GameState state2 = GameState.fromJson(json.decode(json.encode(state1.toJson())));
      expect(state1, state2);
    });
  });
  group("BigTile", () {
    test("new", () {
      BigTile state1 = BigTile();
      BigTile state2 = BigTile();
      expect(state1, state2);
    });
    test("from Json", () {
      BigTile state1 = BigTile();
      state1.tiles[0].state = State.p1;
      state1.tiles[1].state = State.p2;
      state1.tiles[4].state = State.p1;
      state1.tiles[7].state = State.p1;
      state1.tiles[8].state = State.p1;
      BigTile state2 = BigTile.fromJson(json.decode(json.encode(state1.toJson())));
      expect(state1, state2);
    });
  });
  group("Tile", () {
    test("new", () {
      Tile state1 = Tile();
      Tile state2 = Tile();
      expect(state1, state2);
    });
    test("from Json", () {
      Tile state1 = Tile();
      state1.state = State.p1;
      Tile state2 = Tile.fromJson(json.decode(json.encode(state1.toJson())));
      expect(state1, state2);
    });
  });
  group("State", () {
    test("new", () {
      expect(State.p1, State.p1);
      expect(State.p1 == State.p2, false);
      expect(State.p1 == State.none, false);
      expect(State.p2 == State.none, false);
    });
    test("from Json", () {
      State state1 = State.fromJson(json.decode('{"state":"."}'));
      State state2 = State.fromJson(json.decode(json.encode(state1.toJson())));
      expect(state1, state2);
    });
  });
  group("Move", () {
    test("new", () {
      Move m1 = Move(State.none, 0, 0, 0, 0);
      Move m2 = Move(State.none, 0, 0, 0, 0);
      expect(m1, m2);
    });
    test("from Json", () {
      Move m1 = Move(State.none, 2, 0, 2, 0);
      Move m2 = Move.fromJson(json.decode(json.encode(m1.toJson())));
      expect(m1, m2);
    });
  });
}