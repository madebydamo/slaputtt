part of evolution;

Generation _mutateGeneration(Generation generation) {
  List<Rating> list = [];
  generation.ratings.sort();
  if (generation.ratings.length.isEven) {
    for (int i = generation.ratings.length ~/ 2 + 1; i <
        generation.ratings.length; i++) {
      list.add(Rating(_mutateDNA(generation.ratings[i].dna)));
      list.add(Rating(_mutateDNA(generation.ratings[i].dna)));
    }
    list.add(Rating(
        _mutateDNA(generation.ratings[generation.ratings.length ~/ 2].dna)));
    list.add(Rating(generation.ratings[generation.ratings.length - 1].dna));
  } else {
    for (int i = (generation.ratings.length + 1) ~/ 2; i <
        generation.ratings.length; i++) {
      list.add(Rating(_mutateDNA(generation.ratings[i].dna)));
      list.add(Rating(_mutateDNA(generation.ratings[i].dna)));
    }
    list.add(Rating(generation.ratings[generation.ratings.length - 1].dna));
  }
  assert(list.length == generation.ratings
      .length, "Old generation and mutated generation doesn't have the same size");
  return Generation(list);
}

DNA _mutateDNA(DNA dna) {
  double mutation = _mutateNumber(dna.mutation, dna.mutation);
  return DNA(_mutateNumber(dna.smallOne, mutation),
      _mutateNumber(dna.smallTwo, mutation),
      _mutateNumber(dna.bigOne, mutation),
      _mutateNumber(dna.bigTwo, mutation),
      _mutateNumber(dna.bigThree, mutation),
      mutation);
}

double _mutateNumber(double d, double mutation) {
  Random r = Random();
  return d * (r.nextDouble() * mutation * 2 + (1 - mutation));
}

Era initialiseEra(int size, depth) {
  Era era = Era(depth);
  Generation gen1 = Generation(
      List.generate(size, (i) => Rating(_randomDNA())));
  era.generations.add(gen1);
  return era;
}

DNA _randomDNA() {
  Random r = Random();
  double smallOne = r.nextDouble() * 2000;
  double smallTwo = r.nextDouble() * 2000;
  double bigOne = r.nextDouble() * 2000;
  double bigTwo = r.nextDouble() * 2000;
  double bigThree = r.nextDouble() * 2000;

  return DNA(smallOne, smallTwo, bigOne, bigTwo, bigThree, 0.2);
}


void mutate(Era era) {
  assert(era.currentState == trained, "You have to train your generation first!");
  Generation generation = era.lastTrainedGen;
  era.generations.add(_mutateGeneration(generation));
  era.currentState = mutated;
}