import 'package:meta/meta.dart';

class MovieShortDetails {
  MovieShortDetails({
    @required this.id,
    @required this.title,
    @required this.posterUrl,
  })  : assert(id != null),
        assert(title != null),
        assert(posterUrl != null);

  int id;
  String title;
  String posterUrl;
}
