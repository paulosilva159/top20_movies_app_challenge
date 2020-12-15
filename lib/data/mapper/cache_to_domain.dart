import 'package:domain/model/model.dart';

import 'package:tokenlab_challenge/data/cache/model/movies_cache_model.dart';

extension MovieLongDetailsCMMappers on MovieLongDetailsCM {
  MovieLongDetails toDomainModel(bool isFavorite) => MovieLongDetails(
      id: id,
      tagline: tagline,
      title: title,
      voteAverage: voteAverage,
      voteCount: voteCount,
      overview: overview,
      isFavorite: isFavorite);
}

extension MovieShortDetailsCMMappers on MovieShortDetailsCM {
  MovieShortDetails toDomainModel(bool isFavorite) => MovieShortDetails(
        id: id,
        title: title,
        posterUrl: posterUrl,
        isFavorite: isFavorite,
      );
}
