part of 'Evolution.dart';

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