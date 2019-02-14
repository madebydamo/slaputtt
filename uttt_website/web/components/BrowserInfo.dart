import 'dart:html';

import 'package:platform_detect/platform_detect.dart';

class BrowserInfo {
  static BrowserInfo _browserInfo;

  factory BrowserInfo() {
    if (_browserInfo == null) _browserInfo = BrowserInfo._();
    return _browserInfo;
  }

  BrowserInfo._() {
    if (!browser.isChrome && !browser.isFirefox) {
      querySelector("#browserinfo").innerHtml =
          "Compatibility is only guaranteed with the latest versions of Chrome and Firefox.";
    }
  }
}
