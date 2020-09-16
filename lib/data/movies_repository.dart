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

  Future<MovieLongDetailsCM> getMovieDetails(int movieId) async {
    MovieLongDetailsCM movieDetails;

    await cacheDataSource
        .getMovieDetails(movieId)
        .then((value) => movieDetails = value)
        .catchError((error) async {
      if (error is RangeError) {
        await remoteDataSource.getMovieDetails(movieId).then((details) {
          upsertMovieDetails(details);

          movieDetails = _toLongCacheModel(details);
        });
      }
    });
    return movieDetails;
  }

  Future<List<MovieShortDetailsCM>> getMoviesList() async {
    List<MovieShortDetailsCM> moviesList;

    await cacheDataSource
        .getMoviesList()
        .then((value) => moviesList = value)
        .catchError((error) async {
      print(error);
      if (error is RangeError) {
        await remoteDataSource.getMoviesList().then((value) {
          upsertMoviesList(value);

          moviesList = value.map(_toShortCacheModel).toList();
        });
      }
    });

    return moviesList;
  }

  Future<List<int>> getFavorites() async {
    List<int> favorites;

    await cacheDataSource
        .getFavorites()
        .then((favoritesId) => favorites = favoritesId)
        .catchError(print);

    return favorites;
  }

  Future<void> upsertMoviesList(List<MovieShortDetailsRM> moviesList) =>
      cacheDataSource.upsertMoviesList(
        moviesList.map<MovieShortDetailsCM>(_toShortCacheModel).toList(),
      );

  Future<void> upsertMovieDetails(MovieLongDetailsRM movieDetails) =>
      cacheDataSource.upsertMovieDetails(
        _toLongCacheModel(movieDetails),
      );

  Future<void> upsertFavoriteMovieId(int movieId) =>
      cacheDataSource.upsertFavoriteMovieId(movieId);

  Future<void> removeMoviesList() => cacheDataSource.removeMoviesList();

  Future<void> removeMovieDetails(MovieLongDetailsCM movieDetails) =>
      cacheDataSource.removeMovieDetails(movieDetails);

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
