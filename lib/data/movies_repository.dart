import 'package:meta/meta.dart';

import 'model/model.dart';
import 'sources/sources.dart';

class MoviesRepository {
  MoviesRepository(
      {@required this.remoteDataSource, @required this.cacheDataSource})
      : assert(remoteDataSource != null),
        assert(cacheDataSource != null);

  final MoviesRemoteDataSource remoteDataSource;
  final MoviesCacheDataSource cacheDataSource;

  Future<MovieLongDetailsCM> getMovieDetails(int movieId) =>
      cacheDataSource.getMovieDetails(movieId).catchError((error) =>
          remoteDataSource.getMovieDetails(movieId).then(_toLongCacheModel)
            ..then(_upsertMovieDetails));

  Future<List<MovieShortDetailsCM>> getMoviesList() =>
      cacheDataSource.getMoviesList().catchError((error) => remoteDataSource
          .getMoviesList()
          .then((movies) => movies.map(_toShortCacheModel).toList())
            ..then(_upsertMoviesList));

  Future<List<MovieShortDetailsCM>> getFavorites() => Future.wait([
        cacheDataSource.getFavorites(),
        cacheDataSource.getMoviesList(),
      ]).then(
        (futureList) {
          final favoritesId = List<int>.from(futureList[0]);
          final moviesList = List<MovieShortDetailsCM>.from(futureList[1]);

          return moviesList
              .where((movie) => favoritesId.contains(movie.id))
              .toList();
        },
      );

  Future<void> _upsertMoviesList(List<MovieShortDetailsCM> moviesList) =>
      cacheDataSource.upsertMoviesList(moviesList);

  Future<void> _upsertMovieDetails(MovieLongDetailsCM movieDetails) =>
      cacheDataSource.upsertMovieDetails(movieDetails);

  Future<void> upsertFavoriteMovieId(int movieId) =>
      cacheDataSource.upsertFavoriteMovieId(movieId);

  Future<void> removeFavoriteMovieId(int movieId) =>
      cacheDataSource.removeFavoriteMovieId(movieId);
}

MovieLongDetailsCM _toLongCacheModel(var movieLongDetails) =>
    MovieLongDetailsCM(
      id: movieLongDetails.id,
      tagline: movieLongDetails.tagline,
      title: movieLongDetails.title,
      voteAverage: movieLongDetails.voteAverage,
      voteCount: movieLongDetails.voteCount,
      overview: movieLongDetails.overview,
    );

MovieShortDetailsCM _toShortCacheModel(var movieShortDetails) =>
    MovieShortDetailsCM(
      id: movieShortDetails.id,
      title: movieShortDetails.title,
      posterUrl: movieShortDetails.posterUrl,
    );
