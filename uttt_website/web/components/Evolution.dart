import 'package:uttt_package/src/model/Evolution.dart';
import 'package:chartjs/chartjs.dart';
import 'dart:html';
import 'dart:async';
import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import '../controller/GameController.dart';
import '../controller/EvolutionWebController.dart' as EvolutionController;

class EvolutionElement {
  static EvolutionElement _evolutionElement;
  Era era;
  int _selectedGen;

  EvolutionElement._() {
    UListElement pagination = UListElement();
    pagination.id = "pagination";
    pagination.classes.add("pagination");
    querySelector("#evolution").children.add(pagination);

    DivElement control = DivElement();
    control.id = "control";
    querySelector("#evolution").children.add(control);


    AnchorElement train = AnchorElement();
    train.innerHtml = "Train";
    train.classes.addAll(["waves-effect", "waves-light", "btn-flat", "right"]);
    train.onClick.listen((e) {
      train.classes.add("disabled");
      EvolutionController.train(era, () {
        train.classes.remove("disabled");
        _visualize(_selectedGen);
      });
    });

    AnchorElement mutate = AnchorElement();
    mutate.innerHtml = "Mutate";
    mutate.classes.addAll(["waves-effect", "waves-light", "btn-flat", "right"]);
    mutate.onClick.listen((e) {
      mutate.classes.add("disabled");
      EvolutionController.mutate(era, () {
        mutate.classes.remove("disabled");
        _visualizePagination();
      });
    });

    control.children.addAll([train, mutate]);
    querySelector("#evolution").children.add(control);

    DivElement generation = DivElement();
    generation.id = "generation";
    generation.classes.add("row");
    querySelector("#evolution").children.add(generation);
  }

  factory EvolutionElement() {
    if (_evolutionElement == null) _evolutionElement = EvolutionElement._();
    return _evolutionElement;
  }

  void setEra(Era era) {
    this.era = era;
    _visualize(era.generations.length - 1);
  }

  void _visualize(int index) {
    _selectedGen = index;
    _visualizePagination();
    _visualizeGeneration();
  }

  void _visualizeGeneration() {
    int y = window.scrollY;
    int x = window.scrollX;

    DivElement root = querySelector("#generation");
    root.children.clear();

    Generation gen = era.generations[_selectedGen];
    List<DivElement> elements = gen.ratings
        .map((r) => RatingElement(r).element)
        .map((element) => DivElement()
          ..classes.addAll(["s6", "m4", "l3", "xl2", "col"])
          ..children.add(element))
        .toList();
    print("Elementslength: ${elements.length}");
    root.children.addAll(elements);
    Timer.periodic(
        Duration(milliseconds: 500), (timer) {
          window.scrollTo(x, y);
          timer.cancel();
    });
  }

  void _visualizePagination() {
    UListElement root = querySelector("#pagination");
    root.children.clear();

    LIElement start = LIElement();
    AnchorElement startLink = AnchorElement();
    startLink.children
        .add(Element.html('<i class="material-icons">chevron_left</i>'));
    start.children.add(startLink);
    if (_selectedGen == 0)
      start.classes.add("disabled");
    else
      startLink.onClick.listen((event) => _visualize(_selectedGen - 1));
    root.children.add(start);

    for (int i = 0; i < era.generations.length; i++) {
      LIElement elem = LIElement();
      AnchorElement elemLink = AnchorElement();
      print("$_selectedGen");
      if (_selectedGen == i)
        elem.classes.add("active");
      else
        elemLink.onClick.listen((event) => _visualize(i));
      elemLink.innerHtml = (i + 1).toString();
      elem.children.add(elemLink);
      root.children.add(elem);
    }

    LIElement end = LIElement();
    AnchorElement endLink = AnchorElement();
    endLink.children
        .add(Element.html('<i class="material-icons">chevron_right</i>'));
    end.children.add(endLink);
    if (_selectedGen == era.generations.length - 1)
      end.classes.add("disabled");
    else
      endLink.onClick.listen((event) => _visualize(_selectedGen + 1));
    root.children.add(end);

    root.children
        .where((child) =>
            !child.classes.contains("disabled") &&
            !child.classes.contains("active"))
        .forEach((child) => child.classes.add("waves-effect"));
  }
}

class RatingElement {
  DivElement root;

  RatingElement._(Rating r) {
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

  factory RatingElement(Rating r) => RatingElement._(r);

  get element => root;
}
