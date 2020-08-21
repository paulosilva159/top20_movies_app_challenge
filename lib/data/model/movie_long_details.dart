class MovieLongDetails {
  MovieLongDetails(
      {this.budget,
      this.genres,
      this.id,
      this.overview,
      this.popularity,
      this.revenue,
      this.posterUrl,
      this.backdropUrl,
      this.tagline,
      this.title,
      this.imdbId,
      this.originalLanguage,
      this.originalTitle,
      this.productionCountries,
      this.releaseDate,
      this.spokenLanguages,
      this.voteAverage,
      this.voteCount});

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
