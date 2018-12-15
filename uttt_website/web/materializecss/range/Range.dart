@JS()
library range;

import 'dart:html';

import 'package:js/js.dart';


//@JS("init")
//external initModal(List<Element> elem, Options options);

@JS("M.Range.init")
external initRange(Element elem);
