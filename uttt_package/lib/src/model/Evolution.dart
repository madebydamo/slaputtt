class DNA {
  double smallOne;
  double smallTwo;
  double bigOne;
  double bigTwo;
  double bigThree;

  DNA(this.smallOne, this.smallTwo, this.bigOne, this.bigTwo, this.bigThree);
}

class Generation {
  List<DNA> organism;
  List<int> order;

  Generation(this.organism){
    order = [];
  }
}

class Era {
  List<Generation> generations;
  int depth;
}