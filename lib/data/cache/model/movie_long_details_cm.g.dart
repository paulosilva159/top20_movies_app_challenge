// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../model/movie_long_details_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieLongDetailsCMAdapter extends TypeAdapter<MovieLongDetailsCM> {
  @override
  final int typeId = 0;

  @override
  MovieLongDetailsCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieLongDetailsCM(
      id: fields[0] as int,
      overview: fields[1] as String,
      tagline: fields[2] as String,
      title: fields[3] as String,
      voteAverage: fields[4] as double,
      voteCount: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MovieLongDetailsCM obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.overview)
      ..writeByte(2)
      ..write(obj.tagline)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.voteAverage)
      ..writeByte(5)
      ..write(obj.voteCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieLongDetailsCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
