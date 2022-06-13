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
  @JsonKey(defaultValue: 0.2) double mutation;

  DNA(this.smallOne, this.smallTwo, this.bigOne, this.bigTwo, this.bigThree, this.mutation);

  factory DNA.fromJson(Map<String, dynamic> json) => _$DNAFromJson(json);

  Map<String, dynamic> toJson() => _$DNAToJson(this);
}

@JsonSerializable()
class Generation {
  List<Rating> ratings;

  Generation(this.ratings);

  DNA get best {
    ratings.sort();
    return ratings[ratings.length - 1].dna;
  }

  factory Generation.fromJson(Map<String, dynamic> json) => _$GenerationFromJson(json);

  Map<String, dynamic> toJson() => _$GenerationToJson(this);
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
    assert(currentState == mutated || currentState == trained, "Invalid CurrentState in Era!");
    int index = currentState == mutated ? generations.length - 2 : generations.length - 1;
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

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);

  Map<String, dynamic> toJson() => _$StatsToJson(this);
}
