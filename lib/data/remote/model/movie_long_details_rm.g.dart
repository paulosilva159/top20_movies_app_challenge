// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_long_details_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieLongDetailsRM _$MovieLongDetailsRMFromJson(Map<String, dynamic> json) {
  return MovieLongDetailsRM(
    id: json['id'] as int,
    overview: json['overview'] as String,
    tagline: json['tagline'] as String,
    title: json['title'] as String,
    voteAverage: (json['vote_average'] as num).toDouble(),
    voteCount: json['vote_count'] as int,
  );
}

Map<String, dynamic> _$MovieLongDetailsRMToJson(MovieLongDetailsRM instance) =>
    <String, dynamic>{
      'id': instance.id,
      'overview': instance.overview,
      'tagline': instance.tagline,
      'title': instance.title,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };
