import 'package:meta/meta.dart';

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
      MovieLongDetails(
        budget: json['budget'],
        genres: json['genres'],
        id: json['id'],
        imdbId: json['imdb_id'],
        originalLanguage: json['original_language'],
        originalTitle: json['original_title'],
        overview: json['overview'],
        popularity: json['popularity'],
        posterUrl: json['poster_url'],
        backdropUrl: json['backdrop_url'],
        releaseDate: json['release_date'],
        revenue: json['revenue'],
        productionCountries: json['production_countries'],
        tagline: json['tagline'],
        title: json['title'],
        spokenLanguages: json['spoken_languages'],
        voteAverage: json['vote_average'],
        voteCount: json['vote_count'],
      );

  int budget;
  List genres;
  int id;
  String imdbId;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterUrl;
  String backdropUrl;
  String releaseDate;
  int revenue;
  List productionCountries;
  List spokenLanguages;
  String tagline;
  String title;
  double voteAverage;
  int voteCount;
}
