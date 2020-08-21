class MovieShortDetails {
  MovieShortDetails(
      {this.id,
      this.voteAverage,
      this.title,
      this.posterUrl,
      this.genres,
      this.releaseDate});

  factory MovieShortDetails.fromJson(Map<String, dynamic> json) =>
      MovieShortDetails(
        id: json['id'],
        voteAverage: json['vote_average'],
        title: json['title'],
        posterUrl: json['poster_url'],
        genres: json['genres'],
        releaseDate: json['release_date'],
      );

  int id;
  double voteAverage;
  String title;
  String posterUrl;
  List genres;
  String releaseDate;
}
