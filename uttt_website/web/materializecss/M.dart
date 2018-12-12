@JS("M")
library m;

import 'package:js/js.dart';

@JS("toast")
external void toast(ToastOptions);

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
