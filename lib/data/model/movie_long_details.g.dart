// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_long_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieLongDetails _$MovieLongDetailsFromJson(Map<String, dynamic> json) {
  return MovieLongDetails(
    budget: json['budget'] as int,
    genres: json['genres'] as List,
    id: json['id'] as int,
    overview: json['overview'] as String,
    popularity: (json['popularity'] as num).toDouble(),
    revenue: json['revenue'] as int,
    posterUrl: json['poster_url'] as String,
    backdropUrl: json['backdrop_url'] as String,
    tagline: json['tagline'] as String,
    title: json['title'] as String,
    imdbId: json['imdb_id'] as String,
    originalLanguage: json['original_language'] as String,
    originalTitle: json['original_title'] as String,
    productionCountries: json['production_countries'] as List,
    releaseDate: json['release_date'] as String,
    spokenLanguages: json['spoken_languages'] as List,
    voteAverage: (json['vote_average'] as num).toDouble(),
    voteCount: json['vote_count'] as int,
  );
}

Map<String, dynamic> _$MovieLongDetailsToJson(MovieLongDetails instance) =>
    <String, dynamic>{
      'budget': instance.budget,
      'genres': instance.genres,
      'id': instance.id,
      'imdb_id': instance.imdbId,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_url': instance.posterUrl,
      'backdrop_url': instance.backdropUrl,
      'release_date': instance.releaseDate,
      'revenue': instance.revenue,
      'production_countries': instance.productionCountries,
      'spoken_languages': instance.spokenLanguages,
      'tagline': instance.tagline,
      'title': instance.title,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };
