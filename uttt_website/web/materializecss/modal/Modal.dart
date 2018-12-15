@JS()
library modal;

import 'dart:html';

import 'package:js/js.dart';


//@JS("init")
//external initModal(List<Element> elem, Options options);

@JS("M.Modal.init")
external initModal(Element elem, ModalOptions options);

@JS("M.Modal.getInstance")
external Modal getInstance(Element elem);

@JS()
@anonymous
class ModalOptions {
  external String get html;

  external num get displayLength;

  external num get inDuration;

  external String get classes;

  external num get outDuration;

  external num get activationPercent;

  external factory ModalOptions({
    String html,
    num displayLength,
    num inDuration,
    String classes,
    num outDuration,
    num activationPercent,
  });
}

@JS()
@anonymous
class Modal {
  external open();
}