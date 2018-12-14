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
import '../materializecss/modal/Modal.dart';
import '../materializecss/range/Range.dart';

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
      if(evolutionController.era != null)
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
    List<DivElement> elements = gen.ratings.reversed
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
    if(r.stats.wins + r.stats.wins + r.stats.wins > 0) {
      DivElement bar = DivElement();
      bar.classes.add("bar");
      bar.style.display = "grid";
      bar.style.gridTemplateColumns = "${r.stats.wins}fr ${r.stats.draws}fr ${r.stats.loses}fr";
      DivElement win = DivElement();
      win.innerHtml = r.stats.wins > 0 ? "${r.stats.wins}" : "";
      win.classes.addAll(["green", "lighten-1", "wihte-text"]);
      DivElement draw = DivElement();
      win.innerHtml = r.stats.draws > 0 ? "${r.stats.draws}" : "";
      draw.classes.addAll(["gray", "lighten-1", "wihte-text"]);
      DivElement lose = DivElement();
      win.innerHtml = r.stats.loses > 0 ? "${r.stats.loses}" : "";
      lose.classes.addAll(["red", "lighten-1", "wihte-text"]);
      bar.children.addAll([win, draw, lose]);
      content.children.add(bar);
    }
    root.children.add(content);

    DivElement action = DivElement()..classes.addAll(["card-action"]);
    AnchorElement play = AnchorElement();
    play.classes.addAll(["waves-effect", "waves-light", "btn-flat"]);
    play.onClick.listen((event) {
      GameController()
          .config(AlphaBetaPruning(3, HeuristicAlphaBeta(r.dna)), true);
      window.scrollTo(0, 0, {"behavior": 'smooth'});
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
    AnchorElement newEra = AnchorElement();
    newEra.innerHtml = "Start new Evolution";
    newEra.classes.addAll(["waves-effect", "waves-light", "btn-flat", "left"]);

    DivElement rightWrapper = DivElement();
    rightWrapper.classes.add("right");

    _train = AnchorElement();
    _train.innerHtml = "Train";
    _train.classes.addAll(["waves-effect", "waves-light", "btn-flat", "right", "disabled"]);

    _mutate = AnchorElement();
    _mutate.innerHtml = "Mutate";
    _mutate.classes.addAll(["waves-effect", "waves-light", "btn-flat", "right", "disabled"]);

    LabelElement repeatLabel = LabelElement();
    InputElement repeat = InputElement(type: "checkbox");
    repeatLabel.children.addAll([repeat, SpanElement()..innerHtml="Repeat"]);
    repeatLabel.classes.addAll(["right", "btn-flat"]);

    rightWrapper.children.addAll([_train, _mutate, repeatLabel]);

    DivElement modal = DivElement();
    modal.id = "newEra";
    modal.classes.add("modal");
    DivElement content = DivElement();
    content.classes.add("modal-content");
    HeadingElement header = HeadingElement.h4();
    header.innerHtml = "New Evolution";
    ParagraphElement description = ParagraphElement();
    description.innerHtml = "You can create your own Era. The larger the " +
        "population and the depth of search, the longer it takes for generations" +
        " to develop. Adjust the parameters on your computer.";
    FormElement form = FormElement();
    form.action = "";
    ParagraphElement populationParagraph = ParagraphElement();
    populationParagraph.innerHtml = "Populationsize";
    ParagraphElement populationWrapper = ParagraphElement();
    populationWrapper.classes.add("range-field");
    InputElement population = InputElement(type: "range");
    population.max = "50";
    population.min = "6";
    population.value = "35";
    population.step = "1";
    populationWrapper.children.add(population);
    ParagraphElement depthParagraph = ParagraphElement();
    depthParagraph.innerHtml = "Depth of search";
    ParagraphElement depthWrapper = ParagraphElement();
    depthWrapper.classes.add("range-field");
    InputElement depth = InputElement(type: "range");
    depth.max = "7";
    depth.min = "1";
    depth.value = "3";
    depth.step = "1";
    depthWrapper.children.add(depth);
    form.children.addAll(
        [populationParagraph, populationWrapper, depthParagraph, depthWrapper]);
    content.children.addAll([header, description, form]);
    DivElement footer = DivElement();
    footer.classes.add("modal-footer");
    AnchorElement create = AnchorElement();
    create.innerHtml = "Start new Evolution";
    create.classes.addAll(["modal-close", "waves-effect", "waves-light", "btn-flat"]);
    create.onClick.listen((e) {
      era = EvolutionController.initialiseEra(int.tryParse(population.value), int.tryParse(depth.value));
      visualize();
    });
    AnchorElement abort = AnchorElement();
    abort.innerHtml = "Abort";
    abort.classes.addAll(["modal-close", "waves-effect", "waves-light", "btn-flat"]);
    footer.children.addAll([create, abort]);
    modal.children.addAll([content, footer]);

    newEra.onClick.listen((e) {
      getInstance(modal).open();
    });
    _train.onClick.listen((e) async {
      _train.classes.add("disabled");
      await EvolutionController.train(era);
      visualize();
      _visualize();
      if(repeat.checked)
        _mutate.click();
    });
    _mutate.onClick.listen((e) {
      _mutate.classes.add("disabled");
      EvolutionController.mutate(era);
      visualize();
      _visualize();

      if(repeat.checked)
        _train.click();
    });

    root.children.addAll([newEra, rightWrapper, modal]);

//    Timer(Duration(seconds: 3), () => initModal(modal, ModalOptions()));
//    Timer(Duration(seconds: 3), () => initRange(depth));
//    Timer(Duration(seconds: 3), () => initRange(population));
    initModal(modal, ModalOptions());
    initRange(depth);
    initRange(population);
//    initModal(modal, ModalOptions());
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

