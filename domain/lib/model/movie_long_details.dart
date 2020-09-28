import 'package:meta/meta.dart';

class MovieLongDetails {
  MovieLongDetails(
      {@required this.id,
      @required this.overview,
      @required this.tagline,
      @required this.title,
      @required this.voteAverage,
      @required this.voteCount,
      @required this.isFavorite})
      : assert(id != null),
        assert(overview != null),
        assert(tagline != null),
        assert(title != null),
        assert(voteAverage != null),
        assert(voteCount != null),
        assert(isFavorite != null);

  int id;
  String overview;
  String tagline;
  String title;
  double voteAverage;
  int voteCount;
  bool isFavorite;
}
