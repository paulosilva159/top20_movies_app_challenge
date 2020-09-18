import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_short_details_rm.g.dart';

@JsonSerializable(nullable: false)
class MovieShortDetailsRM {
  MovieShortDetailsRM({
    @required this.id,
    @required this.title,
    @required this.posterUrl,
  })  : assert(id != null),
        assert(title != null),
        assert(posterUrl != null);

  factory MovieShortDetailsRM.fromJson(Map<String, dynamic> json) =>
      _$MovieShortDetailsRMFromJson(json);

  Map<String, dynamic> toJson() => _$MovieShortDetailsRMToJson(this);

  int id;
  String title;
  @JsonKey(name: 'poster_url')
  String posterUrl;
}
