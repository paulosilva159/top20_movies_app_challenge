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
      if (error is RangeError) {
        await remoteDataSource.getMoviesList().then((value) {
          upsertMoviesList(value);

          moviesList = value.map(_toShortCacheModel).toList();
        });
      }
    });

    return moviesList;
  }

  Future<List<int>> getFavoritesId() => cacheDataSource
      .getFavorites()
      .then((favorites) => favorites.keys.toList());

  Future<Map<int, String>> getFavorites() async {
    Map<int, String> favorites;

    await cacheDataSource
        .getFavorites()
        .then((favoritesMap) => favorites = favoritesMap)
        .catchError(print);

    return favorites;
  }

  void upsertMoviesList(List<MovieShortDetailsRM> moviesList) {
    cacheDataSource.upsertMoviesList(
      moviesList.map<MovieShortDetailsCM>(_toShortCacheModel).toList(),
    );
  }

  void upsertMovieDetails(MovieLongDetailsRM movieDetails) {
    cacheDataSource.upsertMovieDetails(
      _toLongCacheModel(movieDetails),
    );
  }

  void upsertFavoriteMovieId(int movieId, String movieName) {
    cacheDataSource.upsertFavoriteMovieId(movieId, movieName);
  }

  void removeMoviesList() {
    cacheDataSource.removeMoviesList();
  }

  void removeMovieDetails(MovieLongDetailsCM movieDetails) {
    cacheDataSource.removeMovieDetails(movieDetails);
  }

  void removeFavoriteMovieId(int movieId) {
    cacheDataSource.removeFavoriteMovieId(movieId);
  }
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
