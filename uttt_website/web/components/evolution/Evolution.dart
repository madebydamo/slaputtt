library evolution;

import 'dart:async';
import 'dart:html';
import 'dart:core';

import 'package:uttt_package/src/model/Evolution.dart';

import 'Rating.dart';
import 'Controller.dart';

class EvolutionElement {
  static EvolutionElement _evolutionElement;
  int _selectedGen;
  ControlElement evolutionController;

  EvolutionElement._() {
    UListElement pagination = UListElement();
    pagination.id = "pagination";
    pagination.classes.add("pagination");
    querySelector("#evolution").children.add(pagination);

    DivElement control = DivElement();
    control.id = "control";
    querySelector("#evolution").children.add(control);

    evolutionController = ControlElement(control, _visualize);

    querySelector("#evolution").children.add(control);

    DivElement generation = DivElement();
    generation.id = "generation";
    generation.classes.add("row");
    querySelector("#evolution").children.add(generation);

    window.onResize.listen((e) {
      if (evolutionController.era != null) _visualizePagination();
    });
  }

  factory EvolutionElement() {
    if (_evolutionElement == null) _evolutionElement = EvolutionElement._();
    return _evolutionElement;
  }

  void setEra(Era era) {
    evolutionController.era = era;
    _selectedGen = era.generations.length - 1;
    _visualize();
  }

  void _visualize() {
    if (_selectedGen >= evolutionController.era.generations.length) {
      _selectedGen = evolutionController.era.generations.length - 1;
    }
    _visualizePagination();
    _visualizeGeneration();
  }

  void _visualizeGeneration() {
    DivElement root = querySelector("#generation");
    root.style.height = "${root.clientHeight}px";
    root.children.clear();

    Generation gen = evolutionController.era.generations[_selectedGen];
    List<DivElement> elements = gen.ratings.reversed
        .map((r) => RatingElement(r).element)
        .map((element) => DivElement()
          ..classes.addAll(["s6", "m4", "l3", "xl2", "col"])
          ..children.add(element))
        .toList();
    root.children.addAll(elements);
    Timer(Duration(milliseconds: 500), () {
      root.style.height = "";
    });
  }

  void _visualizePagination() {
    UListElement root = querySelector("#pagination");
    int elements = ((root.clientWidth - 20) ~/ 40) - 2;
    int eraLength = evolutionController.era.generations.length;
    int startElem = _selectedGen - (elements ~/ 2);
    if (startElem < 0) {
      startElem = 0;
    }
    int endElem = startElem + elements;
    if (endElem > eraLength) {
      startElem -= endElem - eraLength;
      endElem = eraLength;
    }
    if (startElem < 0) {
      startElem = 0;
    }

    root.children.clear();

    LIElement start = LIElement();
    AnchorElement startLink = AnchorElement();
    startLink.children
        .add(Element.html('<i class="material-icons">first_page</i>'));
    start.children.add(startLink);
    if (_selectedGen == 0)
      start.classes.add("disabled");
    else
      startLink.onClick.listen((event) {
        _selectedGen = 0;
        _visualize();
      });
    root.children.add(start);

    for (int i = startElem; i < endElem; i++) {
      LIElement elem = LIElement();
      AnchorElement elemLink = AnchorElement();
      if (_selectedGen == i)
        elem.classes.add("active");
      else
        elemLink.onClick.listen((event) {
          _selectedGen = i;
          _visualize();
        });
      elemLink.innerHtml = (i + 1).toString();
      elem.children.add(elemLink);
      root.children.add(elem);
    }

    LIElement end = LIElement();
    AnchorElement endLink = AnchorElement();
    endLink.children
        .add(Element.html('<i class="material-icons">last_page</i>'));
    end.children.add(endLink);
    if (_selectedGen == eraLength - 1)
      end.classes.add("disabled");
    else
      endLink.onClick.listen((event) {
        _selectedGen = eraLength - 1;
        _visualize();
      });
    root.children.add(end);

    root.children
        .where((child) =>
            !child.classes.contains("disabled") &&
            !child.classes.contains("active"))
        .forEach((child) => child.classes.add("waves-effect"));
  }
}
