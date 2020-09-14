import 'model/model.dart';
import 'source/source.dart';

class MoviesRepository {
  final MoviesRemoteDataSource _remoteDataSource = MoviesRemoteDataSource();
  final MoviesCacheDataSource _cacheDataSource = MoviesCacheDataSource();

  Future getMovieDetails(int movieId) async {
    dynamic movieDetails;

    await _cacheDataSource
        .getMovieDetails(movieId)
        .then((value) => movieDetails = value)
        .catchError((error) async {
      if (error is RangeError) {
        await _remoteDataSource.getMovieDetails(movieId).then((details) {
          upsertMovieDetails(details);

          movieDetails = details;
        });
      }
    });
    return movieDetails;
  }

  Future<List> getMoviesList() async {
    dynamic moviesList;

    await _cacheDataSource
        .getMoviesList()
        .then((value) => moviesList = value)
        .catchError((error) async {
      if (error is RangeError) {
        await _remoteDataSource.getMoviesList().then((value) {
          upsertMoviesList(value);

          moviesList = value;
        });
      }
    });

    return moviesList;
  }

  Future<List<int>> getFavoritesId() => _cacheDataSource
      .getFavorites()
      .then((favorites) => favorites.keys.toList());

  Future<Map<int, String>> getFavorites() async {
    Map<int, String> favorites;

    await _cacheDataSource
        .getFavorites()
        .then((favoritesMap) => favorites = favoritesMap)
        .catchError(print);

    return favorites;
  }

  void upsertMoviesList(List moviesList) {
    _cacheDataSource.upsertMoviesList(
      moviesList.map<MovieShortDetailsCM>(_toShortCacheModel).toList(),
    );
  }

  void upsertMovieDetails(dynamic movieDetails) {
    _cacheDataSource.upsertMovieDetails(
      _toLongCacheModel(movieDetails),
    );
  }

  void upsertFavoriteMovieId(int movieId, String movieName) {
    _cacheDataSource.upsertFavoriteMovieId(movieId, movieName);
  }

  void removeMoviesList() {
    _cacheDataSource.removeMoviesList();
  }

  void removeMovieDetails(MovieLongDetailsCM movieDetails) {
    _cacheDataSource.removeMovieDetails(movieDetails);
  }

  void removeFavoriteMovieId(int movieId) {
    _cacheDataSource.removeFavoriteMovieId(movieId);
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
