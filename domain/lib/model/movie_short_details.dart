import 'package:meta/meta.dart';

class MovieShortDetails {
  MovieShortDetails({
    @required this.id,
    @required this.title,
    @required this.posterUrl,
    @required this.isFavorite,
  })  : assert(id != null),
        assert(title != null),
        assert(isFavorite != null),
        assert(posterUrl != null);

  int id;
  String title;
  bool isFavorite;
  String posterUrl;
}
