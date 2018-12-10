@JS()
library evolution;

import 'dart:async';
import 'dart:html';

import 'package:chartjs/chartjs.dart';
import 'package:js/js.dart';
import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import 'package:uttt_package/src/model/Evolution.dart';

import '../controller/EvolutionWebController.dart' as EvolutionController;
import '../controller/GameController.dart';
import '../jswrapper/MaterializeCss.dart';

class EvolutionElement {
  static EvolutionElement _evolutionElement;
  int _selectedGen;
  _ControlElement evolutionController;

  EvolutionElement._() {
    UListElement pagination = UListElement();
    pagination.id = "pagination";
    pagination.classes.add("pagination");
    querySelector("#evolution").children.add(pagination);

    DivElement control = DivElement();
    control.id = "control";
    querySelector("#evolution").children.add(control);


    evolutionController = _ControlElement(control, _visualize);

    querySelector("#evolution").children.add(control);

    DivElement generation = DivElement();
    generation.id = "generation";
    generation.classes.add("row");
    querySelector("#evolution").children.add(generation);

    window.onResize.listen((e) {
      _visualizePagination();
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
    if(_selectedGen >= evolutionController.era.generations.length) {
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
    List<DivElement> elements = gen.ratings
        .map((r) => _RatingElement(r).element)
        .map((element) => DivElement()
          ..classes.addAll(["s6", "m4", "l3", "xl2", "col"])
          ..children.add(element))
        .toList();
    root.children.addAll(elements);
    Timer(
        Duration(milliseconds: 500), () {
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

class _RatingElement {
  DivElement root;

  _RatingElement._(Rating r) {
    root = DivElement();
    root.classes.addAll(["card", "grey", "lighten-3", "hoverable"]);
    DivElement content = DivElement()
      ..classes.addAll(["card-content"])
      ..style.padding = "0";
    initChart(content, r.dna);
    root.children.add(content);

    DivElement action = DivElement()..classes.addAll(["card-action"]);
    AnchorElement play = AnchorElement();
    play.classes.addAll(["waves-effect", "waves-light", "btn-flat"]);
    play.onClick.listen((event) {
      GameController()
          .config(AlphaBetaPruning(3, HeuristicAlphaBeta(r.dna)), true);
    });
    play.innerHtml = "Play";
    action.children.add(play);
    root.children.add(action);
  }

  void initChart(Element parent, DNA dna) {
    CanvasElement area = CanvasElement();
    parent.children.add(area);

    var data = new LinearChartData(labels: [
      "",
      "",
      "",
      "",
      ""
    ], datasets: <ChartDataSets>[
      new ChartDataSets(label: '', data: [
        dna.smallOne,
        dna.smallTwo,
        dna.bigOne,
        dna.bigTwo,
        dna.bigThree
      ]),
    ]);

    var config = new ChartConfiguration(
        type: 'line',
        data: data,
        options: new ChartOptions(
            responsive: true,
            legend: ChartLegendOptions(display: false),
            scales: ChartScales(
              xAxes: [ChartXAxe(display: false)],
              yAxes: [ChartYAxe(display: false)],
            )));

    new Chart(area, config);
  }

  factory _RatingElement(Rating r) => _RatingElement._(r);

  get element => root;
}

class _ControlElement {
  Era _era;
  AnchorElement _train;
  AnchorElement _mutate;

  _ControlElement(Element root, void Function() visualize) {
    DivElement modal = DivElement();
    AnchorElement newEra = AnchorElement(href: "#newEra");
    newEra.innerHtml = "Start new Evolution";
    newEra.classes.addAll(["waves-effect", "waves-light", "btn-flat", "left"]);
    newEra.onClick.listen((e) {
      getInstance(modal).open();
    });

    _train = AnchorElement();
    _train.innerHtml = "Train";
    _train.classes.addAll(["waves-effect", "waves-light", "btn-flat", "right", "disabled"]);
    _train.onClick.listen((e) {
      _train.classes.add("disabled");
      EvolutionController.train(era, () {
        visualize();
        _visualize();
      });
    });

    _mutate = AnchorElement();
    _mutate.innerHtml = "Mutate";
    _mutate.classes.addAll(["waves-effect", "waves-light", "btn-flat", "right", "disabled"]);
    _mutate.onClick.listen((e) {
      _mutate.classes.add("disabled");
      EvolutionController.mutate(era, () {
        visualize();
        _visualize();
      });
    });


    modal.id = "newEra";
    modal.classes.add("modal");
    DivElement content = DivElement();
    content.classes.add("modal-content");

    DivElement footer = DivElement();
    footer.classes.add("modal-footer");
    AnchorElement create = AnchorElement();
    create.innerHtml = "Start new Evolution";
    create.classes.addAll(["modal-close", "waves-effect", "waves-light", "btn-flat"]);
    create.onClick.listen((e) {
      era = EvolutionController.initialiseEra(20, 3);
      visualize();
    });
    AnchorElement abort = AnchorElement();
    abort.innerHtml = "Abort";
    abort.classes.addAll(["modal-close", "waves-effect", "waves-light", "btn-flat"]);
    footer.children.addAll([create, abort]);

    modal.children.addAll([content, footer]);

    root.children.addAll([newEra, _train, _mutate, modal]);

    Timer(Duration(seconds: 3), () {
      print("Modal initialised");
      initModal(modal, Options());
    });
  }

  set era (Era era) {
    _era = era;
    _visualize();
  }

  Era get era => _era;

  _visualize() {
    if(era.currentState == trained) {
      _mutate.classes.remove("disabled");
    } else {
      assert(era.currentState == mutated);
      _train.classes.remove("disabled");
    }
  }

}

