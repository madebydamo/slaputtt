// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Evolution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DNA _$DNAFromJson(Map<String, dynamic> json) {
  return DNA(
      (json['smallOne'] as num)?.toDouble(),
      (json['smallTwo'] as num)?.toDouble(),
      (json['bigOne'] as num)?.toDouble(),
      (json['bigTwo'] as num)?.toDouble(),
      (json['bigThree'] as num)?.toDouble(),
      (json['mutation'] as num)?.toDouble() ?? 0.2);
}

Map<String, dynamic> _$DNAToJson(DNA instance) => <String, dynamic>{
      'smallOne': instance.smallOne,
      'smallTwo': instance.smallTwo,
      'bigOne': instance.bigOne,
      'bigTwo': instance.bigTwo,
      'bigThree': instance.bigThree,
      'mutation': instance.mutation
    };

Generation _$GenerationFromJson(Map<String, dynamic> json) {
  return Generation((json['ratings'] as List)
      ?.map(
          (e) => e == null ? null : Rating.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$GenerationToJson(Generation instance) =>
    <String, dynamic>{'ratings': instance.ratings};

Era _$EraFromJson(Map<String, dynamic> json) {
  return Era(json['depth'] as int)
    ..generations = (json['generations'] as List)
        ?.map((e) =>
            e == null ? null : Generation.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..currentState = json['currentState'] as String;
}

Map<String, dynamic> _$EraToJson(Era instance) => <String, dynamic>{
      'generations': instance.generations,
      'depth': instance.depth,
      'currentState': instance.currentState
    };

Rating _$RatingFromJson(Map<String, dynamic> json) {
  return Rating(json['dna'] == null
      ? null
      : DNA.fromJson(json['dna'] as Map<String, dynamic>))
    ..stats = json['stats'] == null
        ? null
        : Stats.fromJson(json['stats'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RatingToJson(Rating instance) =>
    <String, dynamic>{'stats': instance.stats, 'dna': instance.dna};

Stats _$StatsFromJson(Map<String, dynamic> json) {
  return Stats()
    ..wins = json['wins'] as int
    ..draws = json['draws'] as int
    ..loses = json['loses'] as int;
}

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
      'wins': instance.wins,
      'draws': instance.draws,
      'loses': instance.loses
    };

ParticleGeneration _$ParticleGenerationFromJson(Map<String, dynamic> json) {
  return ParticleGeneration((json['ratings'] as List)
      ?.map((e) =>
          e == null ? null : ParticleRating.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$ParticleGenerationToJson(ParticleGeneration instance) =>
    <String, dynamic>{'ratings': instance.ratings};

ParticleEra _$ParticleEraFromJson(Map<String, dynamic> json) {
  return ParticleEra(json['depth'] as int, json['w'] as double,
      json['c1'] as double, json['c2'] as double)
    ..generations = (json['generations'] as List)
        ?.map((e) => e == null
            ? null
            : ParticleGeneration.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..currentState = json['currentState'] as String;
}

Map<String, dynamic> _$ParticleEraToJson(ParticleEra instance) =>
    <String, dynamic>{
      'generations': instance.generations,
      'depth': instance.depth,
      'currentState': instance.currentState,
      'w': instance.w,
      'c1': instance.c1,
      'c2': instance.c2,
    };

ParticleRating _$ParticleRatingFromJson(Map<String, dynamic> json) {
  return ParticleRating(json['particle'] == null
      ? null
      : Particle.fromJson(json['particle'] as Map<String, dynamic>))
    ..stats = json['stats'] == null
        ? null
        : Stats.fromJson(json['stats'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ParticleRatingToJson(ParticleRating instance) =>
    <String, dynamic>{'stats': instance.stats, 'particle': instance.particle};

Particle _$ParticleFromJson(Map<String, dynamic> json) {
  return Particle(
      (json['smallOne'] as num)?.toDouble(),
      (json['smallTwo'] as num)?.toDouble(),
      (json['bigOne'] as num)?.toDouble(),
      (json['bigTwo'] as num)?.toDouble(),
      (json['bigThree'] as num)?.toDouble(),
      (json['mutation'] as num)?.toDouble() ?? 0.2)
    ..bestKnownPosition = json['bestKnownPosition'] == null
        ? null
        : DNA.fromJson(json['bestKnownPosition'] as Map<String, dynamic>)
    ..bestStats =
        json['bestStats'] == null ? null : Stats.fromJson(json['bestStats'])
    ..velocity = json['velocity'] == null
        ? null
        : DNA.fromJson(json['velocity'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ParticleToJson(Particle instance) => <String, dynamic>{
      'smallOne': instance.smallOne,
      'smallTwo': instance.smallTwo,
      'bigOne': instance.bigOne,
      'bigTwo': instance.bigTwo,
      'bigThree': instance.bigThree,
      'mutation': instance.mutation,
      'bestKnownPosition': instance.bestKnownPosition,
      'bestStats': instance.bestStats,
      'velocity': instance.velocity,
    };
