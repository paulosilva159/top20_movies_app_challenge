import 'package:meta/meta.dart';

class MovieShortDetails {
  MovieShortDetails({
    @required this.id,
    @required this.title,
    @required this.posterUrl,
    @required this.isFavorite,
  })  : assert(id != null),
        assert(title != null),
        assert(posterUrl != null),
        assert(isFavorite != null);

  int id;
  String title;
  String posterUrl;
  bool isFavorite;
}
