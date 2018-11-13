// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GameState.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameState _$GameStateFromJson(Map<String, dynamic> json) {
  return GameState()
    ..tiles = (json['tiles'] as List)
        ?.map((e) =>
            e == null ? null : BigTile.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..lastMove = json['lastMove'] == null
        ? null
        : Move.fromJson(json['lastMove'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GameStateToJson(GameState instance) =>
    <String, dynamic>{'tiles': instance.tiles, 'lastMove': instance.lastMove};

Move _$MoveFromJson(Map<String, dynamic> json) {
  return Move(
      json['state'] == null
          ? null
          : State.fromJson(json['state'] as Map<String, dynamic>),
      json['xTile'] as int,
      json['yTile'] as int,
      json['xBigTile'] as int,
      json['yBigTile'] as int);
}

Map<String, dynamic> _$MoveToJson(Move instance) => <String, dynamic>{
      'state': instance.state,
      'xBigTile': instance.xBigTile,
      'yBigTile': instance.yBigTile,
      'xTile': instance.xTile,
      'yTile': instance.yTile
    };

Tile _$TileFromJson(Map<String, dynamic> json) {
  return Tile()
    ..state = json['state'] == null
        ? null
        : State.fromJson(json['state'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TileToJson(Tile instance) =>
    <String, dynamic>{'state': instance.state};

BigTile _$BigTileFromJson(Map<String, dynamic> json) {
  return BigTile()
    ..tiles = (json['tiles'] as List)
        ?.map(
            (e) => e == null ? null : Tile.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..state = json['state'] == null
        ? null
        : State.fromJson(json['state'] as Map<String, dynamic>);
}

Map<String, dynamic> _$BigTileToJson(BigTile instance) =>
    <String, dynamic>{'tiles': instance.tiles, 'state': instance.state};

Grid<T> _$GridFromJson<T extends Tile>(Map<String, dynamic> json) {
  return Grid<T>((json['tiles'] as List)
      ?.map((e) => e == null ? null : _TileConverter<T>().fromJson(e))
      ?.toList());
}

Map<String, dynamic> _$GridToJson<T extends Tile>(Grid<T> instance) =>
    <String, dynamic>{
      'tiles': instance.tiles
          ?.map((e) => e == null ? null : _TileConverter<T>().toJson(e))
          ?.toList()
    };
