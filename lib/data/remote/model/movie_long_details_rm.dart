import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_long_details_rm.g.dart';

@JsonSerializable(nullable: false)
class MovieLongDetailsRM {
  MovieLongDetailsRM({
    @required this.id,
    @required this.overview,
    @required this.tagline,
    @required this.title,
    @required this.voteAverage,
    @required this.voteCount,
  })  : assert(id != null),
        assert(overview != null),
        assert(tagline != null),
        assert(title != null),
        assert(voteAverage != null),
        assert(voteCount != null);

  factory MovieLongDetailsRM.fromJson(Map<String, dynamic> json) =>
      _$MovieLongDetailsRMFromJson(json);

  Map<String, dynamic> toJson() => _$MovieLongDetailsRMToJson(this);

  int id;
  String overview;
  String tagline;
  String title;
  @JsonKey(name: 'vote_average')
  double voteAverage;
  @JsonKey(name: 'vote_count')
  int voteCount;
}
