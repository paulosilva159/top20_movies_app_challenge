import 'package:tokenlab_challenge/data/cache/model/movies_cache_model.dart';
import 'package:tokenlab_challenge/data/remote/model/movie_long_details_rm.dart';
import 'package:tokenlab_challenge/data/remote/model/movie_short_details_rm.dart';

extension MovieLongDetailsRMMappers on MovieLongDetailsRM {
  MovieLongDetailsCM toCacheModel() => MovieLongDetailsCM(
        id: id,
        tagline: tagline,
        title: title,
        voteAverage: voteAverage,
        voteCount: voteCount,
        overview: overview,
      );
}

extension MovieShortDetailsRMMappers on MovieShortDetailsRM {
  MovieShortDetailsCM toCacheModel() => MovieShortDetailsCM(
        id: id,
        title: title,
        posterUrl: posterUrl,
      );
}
