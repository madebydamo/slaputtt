@JS()
library m;

import 'package:js/js.dart';

@JS("M.toast")
external void toast(ToastOptions o);

@JS()
@anonymous
class ToastOptions {
  external String get html;

  external num get displayLength;

  external num get inDuration;

  external num get outDuration;

  external String get classes;

  external Function get completeCallback;

  external num get activationPercent;

  external factory ToastOptions({
    String html,
    num displayLength,
    num inDuration,
    num outDuration,
    String classes,
    Function completeCallback,
    num activationPercent,
  });
}
