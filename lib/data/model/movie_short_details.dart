import 'package:meta/meta.dart';

class MovieShortDetails {
  MovieShortDetails(
      {@required this.id,
      @required this.voteAverage,
      @required this.title,
      @required this.posterUrl,
      @required this.genres,
      @required this.releaseDate})
      : assert(id != null),
        assert(voteAverage != null),
        assert(title != null),
        assert(posterUrl != null),
        assert(genres != null),
        assert(releaseDate != null);

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
