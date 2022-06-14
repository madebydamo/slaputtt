import 'dart:html';

import '../controller/GameController.dart';
import '../materializecss/modal/Modal.dart';

class GameOverModal {
    static GameOverModal _gameOverModal;
    DivElement _content, _modal;
    HeadingElement _header;
    ParagraphElement _paragraph;


    factory GameOverModal() {
      if (_gameOverModal == null) {
        _gameOverModal = GameOverModal._internal();
      }
      return _gameOverModal;
    }

    GameOverModal._internal() {
      _modal = DivElement();
      _modal.id = "gameOverModal";

      _modal.classes.add("modal");
      _content = DivElement();
      _content.classes.add("modal-content");
      _header = HeadingElement.h4();
      _paragraph = ParagraphElement();
      _paragraph.classes.add("center-align");

      DivElement footer = DivElement();
      footer.classes.add("modal-footer");

      Element newGameLink = Element.a();
      newGameLink.innerHtml = "New Game";
      List<String> buttonClasses = ["modal-close", "waves-effect", "btn-flat"];
      newGameLink.classes.addAll(buttonClasses);
      footer.children.add(newGameLink);

      newGameLink.onClick.listen((e) {
      GameController gameController = GameController();
      gameController.startGame();
      });

      _content.children.add(_header);
      _content.children.add(_paragraph);
      _modal.children.add(_content);
      _modal.children.add(footer);

      querySelector("body").append(_modal);

      initModal(_modal, ModalOptions(dismissible: false));
    }

    void open(bool won, bool draw) {
      if(won) {
        _header.innerHtml = "Congrats!";
        _paragraph.innerHtml = "You won.";
      } else if (draw) {
        _header.innerHtml = "That was close!";
        _paragraph.innerHtml = "You played tied.";
      } else {
        _header.innerHtml = "It's a great pity!";
        _paragraph.innerHtml = "You lost.";
      }
      getInstance(_modal).open();
    }

}
