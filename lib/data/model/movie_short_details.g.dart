// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_short_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieShortDetails _$MovieShortDetailsFromJson(Map<String, dynamic> json) {
  return MovieShortDetails(
    id: json['id'] as int,
    voteAverage: (json['vote_average'] as num).toDouble(),
    title: json['title'] as String,
    posterUrl: json['poster_url'] as String,
    genres: json['genres'] as List,
    releaseDate: json['release_date'] as String,
  );
}

Map<String, dynamic> _$MovieShortDetailsToJson(MovieShortDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vote_average': instance.voteAverage,
      'title': instance.title,
      'poster_url': instance.posterUrl,
      'genres': instance.genres,
      'release_date': instance.releaseDate,
    };
