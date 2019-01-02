part of 'Evolution.dart';

class _ProgressBar {
  DivElement bar;
  DivElement _done;
  DivElement _progress;
  DivElement _todo;

  _ProgressBar() {
    bar = DivElement();
    bar.classes.addAll(["bar"]);
    bar.style.display = "grid";
    _done = DivElement();
    _done.classes.addAll(["green", "lighten-1", "white-text"]);
    _progress = DivElement();
    _progress.classes.addAll(["lightRed", "lighten-1", "white-text"]);
    _todo = DivElement();
    _todo.classes.addAll(["grey", "lighten-4", "white-text"]);
    bar.children.addAll([_done, _progress, _todo]);
    reset();
  }

  void showProgress(int fullSize, int done, int inProgress) {
    bar.style.gridTemplateColumns =
        "${done}fr ${inProgress}fr ${fullSize - done - inProgress}fr";
  }

  void reset() {
    showProgress(1, 0, 0);
  }
}
