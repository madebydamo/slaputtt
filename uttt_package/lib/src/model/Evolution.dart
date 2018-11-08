class DNA {
  double smallOne;
  double smallTwo;
  double bigOne;
  double bigTwo;
  double bigThree;

  DNA(this.smallOne, this.smallTwo, this.bigOne, this.bigTwo, this.bigThree);
}

class Generation {
  List<Rating> ratings;

  Generation(this.ratings);

  DNA get best {
    ratings.sort();
    return ratings[ratings.length - 1].dna;
  }
}

class Era {
  List<Generation> generations;
  int depth;

  Era(this.depth) {
    generations = [];
  }

  Generation get lastGen {
    return generations[generations.length -1];
  }
}

class Rating implements Comparable<Rating> {
  Stats stats;
  DNA dna;

  Rating(this.dna) {
    stats = Stats();
  }


  @override
  int compareTo(Rating other) {
    return stats.value.compareTo(other.stats.value);
  }

}

class Stats {
  int wins;
  int draws;
  int loses;

  Stats() {
    wins = 0;
    draws = 0;
    loses = 0;
  }

  int get  value => wins * 3 + draws;
}