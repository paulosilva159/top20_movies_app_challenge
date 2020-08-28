import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_short_details.g.dart';

@JsonSerializable(nullable: false)
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
      _$MovieShortDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$MovieShortDetailsToJson(this);

  int id;
  @JsonKey(name: 'vote_average')
  double voteAverage;
  String title;
  @JsonKey(name: 'poster_url')
  String posterUrl;
  List genres;
  @JsonKey(name: 'release_date')
  String releaseDate;
}
