import 'dart:html';

class Navbar {
  static Navbar _navbar;

  factory Navbar() {
    if (_navbar == null) {
      _navbar = Navbar._internal();
    }
    _navbar.loadStandart();
    return _navbar;
  }

  Navbar._internal() {
    querySelectorAll(".navControl").forEach((e) {
      e.onClick.listen((event) {
        _loadColorTheme(e.innerHtml);
      });
    });
  }

  List<String> colorThemes = ["powderblue", "coral", "mint"];

  void loadStandart() {
    Map<String, String> cookies = _getCookies();
    if (cookies.containsKey("theme")) {
      _loadColorTheme(cookies["theme"]);
    } else {
      _loadColorTheme("powderblue");
    }
  }

  Map<String, String> _getCookies() {
    Map<String, String> cookies = Map();
    print(document.cookie.split(";").length);
    document.cookie.split(";").forEach((c) {
      if (c.split("=").length == 2) cookies[c.split("=")[0]] = c.split("=")[1];
    });
    return cookies;
  }

  void _setCookies(Map<String, String> cookies) {
    cookies.entries
        .map((entry) => "${entry.key}=${entry.value}")
        .forEach((s) => document.cookie = s);
  }

  void _loadColorTheme(String innerHtml) {
    colorThemes.forEach((s) {
      if (innerHtml.toLowerCase() == s) {
        (querySelector('#${s}') as LinkElement).disabled = false;
        Map<String, String> cookies = _getCookies();
        cookies["theme"] = innerHtml;
        _setCookies(cookies);
      } else {
        (querySelector('#${s}') as LinkElement).disabled = true;
      }
    });
  }
}
