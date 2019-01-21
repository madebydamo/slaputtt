import 'dart:html';

class Navbar {
  static Navbar _navbar;

  factory Navbar() {
    if (_navbar == null) {
      _navbar = Navbar._internal();
    }
    return _navbar;
  }

  Navbar._internal() {
    querySelectorAll(".navControl").forEach((e) {
      e.onClick.listen((event) {
        loadColorTheme(e.innerHtml);
      });
    });

    loadColorTheme("powderblue");
  }

  List<String> colorThemes = ["powderblue", "coral", "mint"];

  void loadColorTheme(String innerHtml) {
      colorThemes.forEach((s) {
        if (innerHtml.toLowerCase() == s) {
          (querySelector('#${s}') as LinkElement).disabled = false;
          print("true: $innerHtml");
        } else {
          (querySelector('#${s}') as LinkElement).disabled = true;
          print("False: $innerHtml");
        }
      });
   }
}
