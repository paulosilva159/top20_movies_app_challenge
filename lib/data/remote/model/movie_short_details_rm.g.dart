// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_short_details_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieShortDetailsRM _$MovieShortDetailsRMFromJson(Map<String, dynamic> json) {
  return MovieShortDetailsRM(
    id: json['id'] as int,
    title: json['title'] as String,
    posterUrl: json['poster_url'] as String,
  );
}

Map<String, dynamic> _$MovieShortDetailsRMToJson(
        MovieShortDetailsRM instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'poster_url': instance.posterUrl,
    };
