import 'dart:convert';

import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/model/GameState.dart';

const String typ_initialised = "INITIALISED";
const String typ_configured = "CONFIGURED";
const String typ_playMove = "PLAYMOVE";
const String typ_movePlayed = "MOVEPLAYED";
const String typ_configAlgorithm = "CONFIGALGORITHM";
const String typ_playGame = "PLAYGAME";
const String typ_unknown = "UNKNOWN";
const String typ_gameWinner = "GAMEWINNER";

class Transmission {
  String typ;
  dynamic object;

  Transmission.initialised() : this._(typ_initialised, null);

  Transmission.configured() : this._(typ_configured, null);

  Transmission.playMove(GameState obj) : this._(typ_playMove, obj);

  Transmission.movePlayed(GameState obj) : this._(typ_movePlayed, obj);

  Transmission.configAlgorithm(Algorithm obj) : this._(typ_configAlgorithm, obj);

  Transmission.playGame(Algorithm algo, Algorithm algo2)
      : this._(typ_playGame, [algo, algo2]);

  Transmission.gameWinner(State obj) : this._(typ_gameWinner, obj);

  Transmission._(this.typ, this.object);

  factory Transmission.fromJson(Map<dynamic, dynamic> json) {
    if (json["typ"] == typ_initialised) {
      return Transmission._(json["typ"], null);
    } else if (json["typ"] == typ_playMove) {
      return Transmission._(json["typ"], GameState.fromJson(json["object"]));
    }else if (json["typ"] == typ_movePlayed) {
      return Transmission._(json["typ"], GameState.fromJson(json["object"]));
    } else if (json["typ"] == typ_configAlgorithm) {
      return Transmission._(json["typ"], Algorithm.fromJson(json["object"]));
    } else if (json["typ"] == typ_configured) {
      return Transmission._(json["typ"], null);
    } else if (json["typ"] == typ_playGame) {
      return Transmission._(json["typ"], [
        Algorithm.fromJson(json["algo1"]),
        Algorithm.fromJson(json["algo2"]),
      ]);
    } else if (json["typ"] == typ_gameWinner) {
      return Transmission._(json["typ"], State.fromJson(json["object"]));
    }
    return Transmission._(typ_unknown, null);
  }

  Map<String, dynamic> toJson() {
    if (typ == typ_initialised) {
      return {
        "typ": typ,
      };
    } else if (typ == typ_playMove) {
      return {
        "typ": typ,
        "object": (object as GameState).toJson(),
      };
    } else if (typ == typ_movePlayed) {
      return {
        "typ": typ,
        "object": (object as GameState).toJson(),
      };
    } else if (typ == typ_configured) {
      return {
        "typ": typ,
      };
    } else if (typ == typ_configAlgorithm) {
      return {
        "typ": typ,
        "object": (object as Algorithm).toJson(),
      };
    } else if (typ == typ_playGame) {
      return {
        "typ": typ,
        "algo1": (object as List<Algorithm>)[0].toJson(),
        "algo2": (object as List<Algorithm>)[1].toJson(),
      };
    } else if (typ == typ_gameWinner) {
      return {
        "typ": typ,
        "object": (object as State).toJson(),
      };
    }
    return {
      "typ": typ_unknown,
    };
  }

  String toTransmittable() {
    return json.encode(toJson());
  }

  factory Transmission.fromTransmittable(String s) {
    return Transmission.fromJson(json.decode(s));
  }
}
