import 'package:meta/meta.dart';

class MovieLongDetails {
  MovieLongDetails({
    @required this.id,
    @required this.overview,
    @required this.tagline,
    @required this.title,
    @required this.voteAverage,
    @required this.isFavorite,
    @required this.voteCount,
  })  : assert(id != null),
        assert(overview != null),
        assert(tagline != null),
        assert(title != null),
        assert(voteAverage != null),
        assert(isFavorite != null),
        assert(voteCount != null);

  int id;
  String overview;
  String tagline;
  String title;
  double voteAverage;
  bool isFavorite;
  int voteCount;
}
