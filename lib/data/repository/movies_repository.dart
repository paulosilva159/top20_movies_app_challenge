import 'package:meta/meta.dart';

import 'package:tokenlab_challenge/data/cache/data_source/movies_cache_data_source.dart';
import 'package:tokenlab_challenge/data/cache/model/cache_model.dart';
import 'package:tokenlab_challenge/data/remote/data_source/movies_remote_data_source.dart';

class MoviesRepository {
  MoviesRepository(
      {@required this.remoteDataSource, @required this.cacheDataSource})
      : assert(remoteDataSource != null),
        assert(cacheDataSource != null);

  final MoviesRemoteDataSource remoteDataSource;
  final MoviesCacheDataSource cacheDataSource;

  Future<MovieLongDetailsCM> getMovieDetails(int movieId) =>
      cacheDataSource.getMovieDetails(movieId).catchError(
            (error) => remoteDataSource
                .getMovieDetails(movieId)
                .then(_toLongCacheModel)
                .then(
                  (cacheModel) =>
                      _upsertMovieDetails(cacheModel).then((_) => cacheModel),
                ),
          );

  Future<List<MovieShortDetailsCM>> getMoviesList() =>
      cacheDataSource.getMoviesList().catchError(
            (error) => remoteDataSource
                .getMoviesList()
                .then(
                  (movies) => movies.map(_toShortCacheModel).toList(),
                )
                .then(
                  (cacheListModel) => _upsertMoviesList(cacheListModel)
                      .then((_) => cacheListModel),
                ),
          );

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
      ).catchError((error) => <MovieShortDetailsCM>[]);

  Future<bool> getIsFavoriteFromId(int movieId) =>
      cacheDataSource.getFavorites().then(
            (favoritesId) => favoritesId.contains(movieId),
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
