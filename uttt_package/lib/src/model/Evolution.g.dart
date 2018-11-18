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
      (json['bigThree'] as num)?.toDouble());
}

Map<String, dynamic> _$DNAToJson(DNA instance) => <String, dynamic>{
      'smallOne': instance.smallOne,
      'smallTwo': instance.smallTwo,
      'bigOne': instance.bigOne,
      'bigTwo': instance.bigTwo,
      'bigThree': instance.bigThree
    };
