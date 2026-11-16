import 'dart:convert';
import 'dart:html';

import 'components/BrowserInfo.dart';
import 'components/Level.dart';
import 'components/Navbar.dart';
import 'components/Telemetry.dart';
import 'controller/GameController.dart';
import 'package:uttt_package/src/model/Evolution.dart';

void main() {
  trackErrors();
  Navbar();
  BrowserInfo();
  GameController();
  HttpRequest.getString('17_3G70.json').then((jsonString) {
    Era era = Era.fromJson(json.decode(jsonString));
    LevelElement(era);
    track('era/ga/ok');
  }).catchError((e) {
    track('era/ga/error');
    trackError('era');
    window.console.error('Loading the opponents failed: $e');
  });
}
