import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_long_details.g.dart';

@JsonSerializable(nullable: false)
class MovieLongDetails {
  MovieLongDetails(
      {@required this.budget,
      @required this.genres,
      @required this.id,
      @required this.overview,
      @required this.popularity,
      @required this.revenue,
      @required this.posterUrl,
      @required this.backdropUrl,
      @required this.tagline,
      @required this.title,
      @required this.imdbId,
      @required this.originalLanguage,
      @required this.originalTitle,
      @required this.productionCountries,
      @required this.releaseDate,
      @required this.spokenLanguages,
      @required this.voteAverage,
      @required this.voteCount})
      : assert(budget != null),
        assert(genres != null),
        assert(id != null),
        assert(overview != null),
        assert(popularity != null),
        assert(revenue != null),
        assert(posterUrl != null),
        assert(backdropUrl != null),
        assert(tagline != null),
        assert(title != null),
        assert(originalLanguage != null),
        assert(originalTitle != null),
        assert(productionCountries != null),
        assert(releaseDate != null),
        assert(spokenLanguages != null),
        assert(voteAverage != null),
        assert(voteCount != null);

  factory MovieLongDetails.fromJson(Map<String, dynamic> json) =>
      _$MovieLongDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$MovieLongDetailsToJson(this);

  int budget;
  List genres;
  int id;
  @JsonKey(name: 'imdb_id')
  String imdbId;
  @JsonKey(name: 'original_language')
  String originalLanguage;
  @JsonKey(name: 'original_title')
  String originalTitle;
  String overview;
  double popularity;
  @JsonKey(name: 'poster_url')
  String posterUrl;
  @JsonKey(name: 'backdrop_url')
  String backdropUrl;
  @JsonKey(name: 'release_date')
  String releaseDate;
  int revenue;
  @JsonKey(name: 'production_countries')
  List productionCountries;
  @JsonKey(name: 'spoken_languages')
  List spokenLanguages;
  String tagline;
  String title;
  @JsonKey(name: 'vote_average')
  double voteAverage;
  @JsonKey(name: 'vote_count')
  int voteCount;
}
