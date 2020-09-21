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
      cacheDataSource.getMovieDetails(movieId).catchError(
            (error) => remoteDataSource
                .getMovieDetails(movieId)
                .then(_toLongCacheModel)
                .then(
                  (cacheModel) =>
                      _upsertMovieDetails(cacheModel).then((_) => cacheModel),
                ),
          );

  Future<MovieLongDetailsCM> getMovieDetails2(int movieId) => remoteDataSource
      .getMovieDetails(movieId)
      .then(_toLongCacheModel)
      .then(
        (cacheModel) => _upsertMovieDetails(cacheModel).then((_) => cacheModel),
      )
      .catchError(
        (error) => cacheDataSource.getMovieDetails(movieId),
      );

  Future<MovieLongDetailsCM> getMovieDetails3(int movieId) async {
    MovieLongDetailsCM movieDetails;

    try {
      movieDetails = await cacheDataSource.getMovieDetails(movieId);
    } catch (error) {
      movieDetails =
          _toLongCacheModel(await remoteDataSource.getMovieDetails(movieId));

      await _upsertMovieDetails(movieDetails);
    }

    return movieDetails;
  }

  Future<MovieLongDetailsCM> getMovieDetails4(int movieId) async {
    MovieLongDetailsCM movieDetails;

    try {
      movieDetails =
          _toLongCacheModel(await remoteDataSource.getMovieDetails(movieId));

      await _upsertMovieDetails(movieDetails);
    } catch (error) {
      movieDetails = await cacheDataSource.getMovieDetails(movieId);
    }

    return movieDetails;
  }

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

  Future<List<MovieShortDetailsCM>> getMoviesList2() => remoteDataSource
      .getMoviesList()
      .then(
        (movies) => movies.map(_toShortCacheModel).toList(),
      )
      .then(
        (cacheListModel) =>
            _upsertMoviesList(cacheListModel).then((_) => cacheListModel),
      )
      .catchError(
        (error) => cacheDataSource.getMoviesList(),
      );

  Future<List<MovieShortDetailsCM>> getMoviesList3() async {
    List<MovieShortDetailsCM> moviesList;

    try {
      moviesList = await cacheDataSource.getMoviesList();
    } catch (error) {
      moviesList = (await remoteDataSource.getMoviesList())
          .map(_toShortCacheModel)
          .toList();

      await _upsertMoviesList(moviesList);
    }

    return moviesList;
  }

  Future<List<MovieShortDetailsCM>> getMoviesList4() async {
    List<MovieShortDetailsCM> moviesList;

    try {
      moviesList = (await remoteDataSource.getMoviesList())
          .map(_toShortCacheModel)
          .toList();

      await _upsertMoviesList(moviesList);
    } catch (error) {
      moviesList = await cacheDataSource.getMoviesList();
    }

    return moviesList;
  }

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
