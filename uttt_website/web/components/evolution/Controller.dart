import 'dart:html';
import 'dart:core';
import 'dart:convert';

import 'package:uttt_package/src/model/Evolution.dart';

import '../../controller/EvolutionWebController.dart';
import '../../materializecss/modal/Modal.dart';
import '../../materializecss/range/Range.dart';
import '../../materializecss/M.dart';
import 'Evolution.dart';
import 'Progressbar.dart';

class ControlElement {
  Era _era;
  AnchorElement _train;
  AnchorElement _mutate;
  EvolutionWebController _webController;

  ControlElement(Element root, void Function() visualize) {
    _webController = EvolutionWebController();
    DivElement leftWrapper = DivElement();
    leftWrapper.classes.add("left");

    AnchorElement newEra = AnchorElement();
    newEra.innerHtml = "Start new Evolution";
    newEra.classes.addAll(["waves-effect", "waves-light", "btn-flat", "left"]);

    InputElement upload = InputElement(type: "file");
    upload.id = "upload";
    upload.style.display = "none";
    upload.accept =".json";
    upload.classes.addAll(["waves-effect", "waves-light", "btn-flat", "left"]);

    AnchorElement uploadFacade = AnchorElement();
    uploadFacade.innerHtml = "Upload Evolution";
    uploadFacade.classes
        .addAll(["waves-effect", "waves-light", "btn-flat", "left"]);

    AnchorElement download = AnchorElement();
    download.innerHtml = "Download Evolution";
    download.classes
        .addAll(["waves-effect", "waves-light", "btn-flat", "left"]);

    leftWrapper.children.addAll([newEra, upload, uploadFacade, download]);

    DivElement rightWrapper = DivElement();
    rightWrapper.classes.add("right");

    _train = AnchorElement();
    _train.innerHtml = "Train";
    _train.classes.addAll(
        ["waves-effect", "waves-light", "btn-flat", "right", "disabled"]);

    _mutate = AnchorElement();
    _mutate.innerHtml = "Mutate";
    _mutate.classes.addAll(
        ["waves-effect", "waves-light", "btn-flat", "right", "disabled"]);

    LabelElement repeatLabel = LabelElement();
    InputElement repeat = InputElement(type: "checkbox");
    repeatLabel.children.addAll([repeat, SpanElement()..innerHtml = "Repeat"]);
    repeatLabel.classes.addAll(["right", "btn-flat"]);

    rightWrapper.children.addAll([_train, _mutate, repeatLabel]);

    ProgressBar bar = ProgressBar();

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
    create.classes
        .addAll(["modal-close", "waves-effect", "waves-light", "btn-flat"]);
    create.onClick.listen((e) {
      era = _webController.initialiseEra(
          int.tryParse(population.value), int.tryParse(depth.value));
      visualize();
    });
    AnchorElement abort = AnchorElement();
    abort.innerHtml = "Abort";
    abort.classes
        .addAll(["modal-close", "waves-effect", "waves-light", "btn-flat"]);
    footer.children.addAll([create, abort]);
    modal.children.addAll([content, footer]);

    newEra.onClick.listen((e) {
      getInstance(modal).open();
    });
    download.onClick.listen((e) {
      _download("evolution.json", json.encode(_era.toJson()));
    });
    upload.onChange.listen((e) {
      File f = upload.files[0];
      FileReader r = FileReader();
      r.onLoad.listen((e) {
        try {
          EvolutionElement().setEra(Era.fromJson(json.decode(r.result)));
        } catch (e) {
          toast(ToastOptions(html: "File could not be parsed, probably some invalid JSON"));
        }
      });
      r.onError
          .listen((e) => toast(ToastOptions(html: "File could not be readed, ${r.error.message}")));
      r.readAsText(f);
      upload.value = "";
    });
    uploadFacade.onClick.listen((e) => upload.click());
    _train.onClick.listen((e) async {
      _train.classes.add("disabled");
      bar.reset();
      await _webController.train(era, bar.showProgress);
      visualize();
      _visualize();
      if (repeat.checked) _mutate.click();
    });
    _mutate.onClick.listen((e) {
      _mutate.classes.add("disabled");
      bar.reset();
      _webController.mutate(era);
      visualize();
      _visualize();

      if (repeat.checked) _train.click();
    });

    root.children.addAll([leftWrapper, rightWrapper, bar.bar, modal]);

    initModal(modal, ModalOptions());
    initRange(depth);
    initRange(population);
  }

  set era(Era era) {
    _era = era;
    _visualize();
  }

  Era get era => _era;

  _visualize() {
    if (era.currentState == trained) {
      _mutate.classes.remove("disabled");
    } else {
      assert(era.currentState == mutated);
      _train.classes.remove("disabled");
    }
  }

  _download(filename, text) {
    Element element = document.createElement('a');
    element.setAttribute(
        'href', 'data:text/plain;charset=utf-8,' + Uri.encodeComponent(text));
    element.setAttribute('download', filename);

    element.style.display = 'none';
    document.body.children.add(element);

    element.click();

    document.body.children.remove(element);
  }

// Start file download.
//  download("hello.txt","This is the content of my file :)");

}
