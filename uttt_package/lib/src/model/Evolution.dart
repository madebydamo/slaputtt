import 'package:json_annotation/json_annotation.dart';

part 'Evolution.g.dart'; //regenerate with "pub run build_runner build"

const String mutated = "MUTATED";
const String trained = "TRAINED";

@JsonSerializable()
class DNA {
  double smallOne;
  double smallTwo;
  double bigOne;
  double bigTwo;
  double bigThree;
  @JsonKey(defaultValue: 0.2)
  double mutation;

  DNA(this.smallOne, this.smallTwo, this.bigOne, this.bigTwo, this.bigThree,
      this.mutation);

  factory DNA.fromJson(Map<String, dynamic> json) => _$DNAFromJson(json);

  Map<String, dynamic> toJson() => _$DNAToJson(this);
}

class Particle extends DNA {
  DNA bestKnownPosition;
  Stats bestStats;
  DNA velocity;

  Particle(smallOne, smallTwo, bigOne, bigTwo, bigThree, mutation)
      : super(smallOne, smallTwo, bigOne, bigTwo, bigThree, mutation) {
    bestKnownPosition = DNA(0, 0, 0, 0, 0, 0);
    velocity = DNA(0, 0, 0, 0, 0, 0);
    bestStats = Stats();
  }

  factory Particle.fromJson(Map<String, dynamic> json) =>
      _$ParticleFromJson(json);

  Map<String, dynamic> toJson() => _$ParticleToJson(this);
}

@JsonSerializable()
class ParticleGeneration {
  List<ParticleRating> ratings;

  ParticleGeneration(this.ratings);

  DNA get best {
    ratings.sort();
    return ratings[ratings.length - 1].particle;
  }

  factory ParticleGeneration.fromJson(Map<String, dynamic> json) =>
      _$ParticleGenerationFromJson(json);

  Map<String, dynamic> toJson() => _$ParticleGenerationToJson(this);
}

@JsonSerializable()
class Generation {
  List<Rating> ratings;

  Generation(this.ratings);

  DNA get best {
    ratings.sort();
    return ratings[ratings.length - 1].dna;
  }

  factory Generation.fromJson(Map<String, dynamic> json) =>
      _$GenerationFromJson(json);

  Map<String, dynamic> toJson() => _$GenerationToJson(this);
}

@JsonSerializable()
class ParticleEra {
  List<ParticleGeneration> generations;
  int depth;
  String currentState;
  double w;
  double c1;
  double c2;

  ParticleEra(this.depth, this.w, this.c1, this.c2) {
    generations = [];
    currentState = mutated;
  }

  ParticleGeneration get lastTrainedGen {
    assert(currentState == mutated || currentState == trained,
        "Invalid CurrentState in Era!");
    int index = currentState == mutated
        ? generations.length - 2
        : generations.length - 1;
    return generations[index];
  }

  ParticleGeneration get lastGen {
    return generations[generations.length - 1];
  }

  factory ParticleEra.fromJson(Map<String, dynamic> json) =>
      _$ParticleEraFromJson(json);

  Map<String, dynamic> toJson() => _$ParticleEraToJson(this);
}

@JsonSerializable()
class Era {
  List<Generation> generations;
  int depth;
  String currentState;

  Era(this.depth) {
    generations = [];
    currentState = mutated;
  }

  Generation get lastTrainedGen {
    assert(currentState == mutated || currentState == trained,
        "Invalid CurrentState in Era!");
    int index = currentState == mutated
        ? generations.length - 2
        : generations.length - 1;
    return generations[index];
  }

  Generation get lastGen {
    return generations[generations.length - 1];
  }

  factory Era.fromJson(Map<String, dynamic> json) => _$EraFromJson(json);

  Map<String, dynamic> toJson() => _$EraToJson(this);
}

@JsonSerializable()
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

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  Map<String, dynamic> toJson() => _$RatingToJson(this);
}

@JsonSerializable()
class ParticleRating implements Comparable<ParticleRating> {
  Stats stats;
  Particle particle;

  ParticleRating(this.particle) {
    stats = Stats();
  }

  @override
  int compareTo(ParticleRating other) {
    return stats.value.compareTo(other.stats.value);
  }

  factory ParticleRating.fromJson(Map<String, dynamic> json) =>
      _$ParticleRatingFromJson(json);

  Map<String, dynamic> toJson() => _$ParticleRatingToJson(this);
}

@JsonSerializable()
class Stats {
  int wins;
  int draws;
  int loses;

  Stats() {
    wins = 0;
    draws = 0;
    loses = 0;
  }

  int get value => wins * 3 + draws;

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);

  Map<String, dynamic> toJson() => _$StatsToJson(this);
}
