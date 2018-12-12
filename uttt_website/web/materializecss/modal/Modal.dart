@JS("M.Modal")
library Modal;

import 'dart:html';

import 'package:js/js.dart';


//@JS("init")
//external initModal(List<Element> elem, Options options);

@JS("init")
external initModal(Element elem, ModalOptions options);

@JS("getInstance")
external Modal getInstance(Element elem);


@JS()
@anonymous
class ModalOptions {
  external bool get inDuration;

  external bool get outDuration;

  external factory ModalOptions({bool inDuration, bool outDuration});
}

@JS()
@anonymous
class Modal {
  external open();
}