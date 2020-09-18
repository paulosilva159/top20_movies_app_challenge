import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

part 'movie_short_details_cm.g.dart';

@HiveType(typeId: 1)
class MovieShortDetailsCM {
  MovieShortDetailsCM({
    @required this.id,
    @required this.title,
    @required this.posterUrl,
  })  : assert(id != null),
        assert(title != null),
        assert(posterUrl != null);

  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String posterUrl;
}
