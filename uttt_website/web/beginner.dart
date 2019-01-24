import 'dart:convert';
import 'dart:html';

import 'components/Level.dart';
import 'components/Navbar.dart';
import 'controller/GameController.dart';
import 'package:uttt_package/src/model/Evolution.dart';

void main() {
  Navbar();
  GameController();
  HttpRequest.getString('17_3G70.json').then((jsonString) {
    Era era = Era.fromJson(json.decode(jsonString));
    LevelElement(era);
  });
}
