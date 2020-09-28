import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

part 'movie_long_details_cm.g.dart';

@HiveType(typeId: 0)
class MovieLongDetailsCM {
  MovieLongDetailsCM({
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

  @HiveField(0)
  int id;
  @HiveField(1)
  String overview;
  @HiveField(2)
  String tagline;
  @HiveField(3)
  String title;
  @HiveField(4)
  double voteAverage;
  @HiveField(5)
  int voteCount;
}
