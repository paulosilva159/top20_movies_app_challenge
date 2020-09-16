import 'model/model.dart';
import 'source/source.dart';

class MoviesRepository {
  final MoviesRemoteDataSource _remoteDataSource = MoviesRemoteDataSource();
  final MoviesCacheDataSource _cacheDataSource = MoviesCacheDataSource();

  Future<MovieLongDetailsCM> getMovieDetails(int movieId) async {
    MovieLongDetailsCM movieDetails;

    await _cacheDataSource
        .getMovieDetails(movieId)
        .then((value) => movieDetails = value)
        .catchError((error) async {
      if (error is RangeError) {
        await _remoteDataSource.getMovieDetails(movieId).then((details) {
          upsertMovieDetails(details);

          movieDetails = _toLongCacheModel(details);
        });
      }
    });
    return movieDetails;
  }

  Future<List<MovieShortDetailsCM>> getMoviesList() async {
    List<MovieShortDetailsCM> moviesList;

    await _cacheDataSource
        .getMoviesList()
        .then((value) => moviesList = value)
        .catchError((error) async {
      print(error);
      if (error is RangeError) {
        await _remoteDataSource.getMoviesList().then((value) {
          upsertMoviesList(value);

          moviesList = value.map(_toShortCacheModel).toList();
        });
      }
    });

    return moviesList;
  }

  Future<List<int>> getFavorites() async {
    List<int> favorites;

    await _cacheDataSource
        .getFavorites()
        .then((favoritesId) => favorites = favoritesId)
        .catchError(print);

    return favorites;
  }

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
