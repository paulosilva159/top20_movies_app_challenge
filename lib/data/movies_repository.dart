import 'model/model.dart';
import 'source/source.dart';

class MoviesRepository {
  final MoviesRemoteDataSource _remoteDataSource = MoviesRemoteDataSource();
  final MoviesCacheDataSource _cacheDataSource = MoviesCacheDataSource();

  Future<MovieLongDetailsCM> getMovieDetails(int movieId) =>
      _cacheDataSource.getMovieDetails(movieId).catchError(
          (error) => _remoteDataSource.getMovieDetails(movieId).then((details) {
                upsertMovieDetails(details);

                return _toLongCacheModel(details);
              }));

  Future<List<MovieShortDetailsCM>> getMoviesList() => _cacheDataSource
      .getMoviesList()
      .catchError((error) => _remoteDataSource.getMoviesList().then((value) {
            upsertMoviesList(value);

            return value.map(_toShortCacheModel).toList();
          }));

  Future<List<MovieShortDetailsCM>> getFavorites() => Future.wait([
        _cacheDataSource.getFavorites(),
        _cacheDataSource.getMoviesList()
      ]).then(
        (futureList) {
          final favoritesId = List<int>.from(futureList[0]);
          final moviesList = List<MovieShortDetailsCM>.from(futureList[1]);

          return moviesList
              .where((movie) => favoritesId.contains(movie.id))
              .toList();
        },
      );

  Future<void> upsertMoviesList(List<MovieShortDetailsRM> moviesList) =>
      _cacheDataSource.upsertMoviesList(
        moviesList.map<MovieShortDetailsCM>(_toShortCacheModel).toList(),
      );

  Future<void> upsertMovieDetails(MovieLongDetailsRM movieDetails) =>
      _cacheDataSource.upsertMovieDetails(
        _toLongCacheModel(movieDetails),
      );

  Future<void> upsertFavoriteMovieId(int movieId) =>
      _cacheDataSource.upsertFavoriteMovieId(movieId);

  Future<void> removeMoviesList() => _cacheDataSource.removeMoviesList();

  Future<void> removeMovieDetails(MovieLongDetailsCM movieDetails) =>
      _cacheDataSource.removeMovieDetails(movieDetails);

  Future<void> removeFavoriteMovieId(int movieId) =>
      _cacheDataSource.removeFavoriteMovieId(movieId);
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
