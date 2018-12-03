import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/model/Evolution.dart';
import 'package:uttt_package/src/model/Algorithm.dart';
import 'dart:convert';

const String typ_initialised = "INITIALISED";
const String typ_configured = "CONFIGURED";
const String typ_playMove = "PLAYMOVE";
const String typ_movePlayed = "MOVEPLAYED";
const String typ_configAlgorithm = "CONFIGALGORITHM";
const String typ_unknown = "UNKNOWN";

class Transmission {
  String typ;
  dynamic object;

  Transmission.initialised() : this._(typ_initialised, null);

  Transmission.configured() : this._(typ_configured, null);

  Transmission.playMove(GameState obj) : this._(typ_playMove, obj);

  Transmission.movePlayed(GameState obj) : this._(typ_movePlayed, obj);

  Transmission.configAlgorithm(Algorithm obj) : this._(typ_configAlgorithm, obj);

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
