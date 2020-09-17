import 'model/model.dart';
import 'source/source.dart';

class MoviesRepository {
  final MoviesRemoteDataSource _remoteDataSource = MoviesRemoteDataSource();
  final MoviesCacheDataSource _cacheDataSource = MoviesCacheDataSource();

  Future<MovieLongDetailsCM> getMovieDetails(int movieId) =>
      _cacheDataSource.getMovieDetails(movieId).catchError((error) =>
          _remoteDataSource.getMovieDetails(movieId).then(_toLongCacheModel)
            ..then(_upsertMovieDetails));

  Future<List<MovieShortDetailsCM>> getMoviesList() =>
      _cacheDataSource.getMoviesList().catchError((error) => _remoteDataSource
          .getMoviesList()
          .then((movies) => movies.map(_toShortCacheModel).toList())
            ..then(_upsertMoviesList));

  Future<List<MovieShortDetailsCM>> getFavorites() => Future.wait([
        _cacheDataSource.getFavorites(),
        _cacheDataSource.getMoviesList(),
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
      _cacheDataSource.upsertMoviesList(moviesList);

  Future<void> _upsertMovieDetails(MovieLongDetailsCM movieDetails) =>
      _cacheDataSource.upsertMovieDetails(movieDetails);

  Future<void> upsertFavoriteMovieId(int movieId) =>
      _cacheDataSource.upsertFavoriteMovieId(movieId);

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
