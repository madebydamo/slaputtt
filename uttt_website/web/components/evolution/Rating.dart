import 'dart:html';
import 'dart:core';

import 'package:chartjs/chartjs.dart';
import 'package:uttt_package/src/controller/algorithms/AlphaBetaPruning.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicAlphaBeta.dart';
import 'package:uttt_package/src/model/Evolution.dart';

import '../../controller/GameController.dart';

class RatingElement {
  DivElement root;

  RatingElement._(Rating r) {
    root = DivElement();
    root.classes.addAll(["card", "grey", "lighten-3", "hoverable"]);
    DivElement content = DivElement()
      ..classes.addAll(["card-content"])
      ..style.padding = "0";
    initChart(content, r.dna);
    if (r.stats.wins + r.stats.draws + r.stats.loses > 0) {
      DivElement bar = DivElement();
      bar.classes.add("bar");
      bar.style.gridTemplateColumns =
          "${r.stats.wins}fr ${r.stats.draws}fr ${r.stats.loses}fr";
      DivElement win = DivElement();
      win.innerHtml = r.stats.wins > 0 ? "${r.stats.wins}" : "";
      win.classes.addAll(["green", "lighten-1", "wihte-text"]);
      DivElement draw = DivElement();
      win.innerHtml = r.stats.draws > 0 ? "${r.stats.draws}" : "";
      draw.classes.addAll(["grey", "lighten-4", "white-text"]);
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
    DNAChart(parent, dna);
  }

  factory RatingElement(Rating r) => RatingElement._(r);

  get element => root;
}

class DNAChart {
  DNAChart(Element parent, dna) {
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
}
