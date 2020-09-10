import 'model/model.dart';
import 'source/source.dart';

class MoviesRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final CacheDataSource _cacheDataSource = CacheDataSource();

  Future getMovieDetails(int movieId) async {
    dynamic movieDetails;

    try {
      movieDetails = await _cacheDataSource.getMovieDetails(movieId);
    } catch (error) {
      if (error is RangeError) {
        movieDetails = await _remoteDataSource.getMovieDetails(movieId);
      } else {
        rethrow;
      }
    }

    return movieDetails;
  }

  Future getMoviesList() async {
    dynamic moviesList;

    try {
      moviesList = await _cacheDataSource.getMoviesList();
    } catch (error) {
      if (error is RangeError) {
        moviesList = await _remoteDataSource.getMoviesList();
      } else {
        rethrow;
      }
    }

    return moviesList;
  }

  Future<List<int>> getFavorites() async {
    List<int> favoritesList;

    await _cacheDataSource
        .getFavorites()
        .then((favorites) => favoritesList = favorites)
        .catchError(print);

    return favoritesList;
  }

  void saveMoviesList(List moviesList) {
    _cacheDataSource.saveMoviesList(
      moviesList
          .map<MovieShortDetailsCM>(_movieShortDetailsToCacheModel)
          .toList(),
    );
  }

  void saveMovieDetails(dynamic movieDetails) {
    _cacheDataSource.saveMovieDetails(
      _movieLongDetailsToCacheModel(movieDetails),
    );
  }

  void saveFavoriteMovieId(int movieId) {
    _cacheDataSource.saveFavoriteMovieId(movieId);
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

MovieLongDetailsCM _movieLongDetailsToCacheModel(var movieLongDetails) =>
    MovieLongDetailsCM(
      id: movieLongDetails.id,
      tagline: movieLongDetails.tagline,
      title: movieLongDetails.title,
      voteAverage: movieLongDetails.voteAverage,
      voteCount: movieLongDetails.voteCount,
      overview: movieLongDetails.overview,
    );

MovieShortDetailsCM _movieShortDetailsToCacheModel(var movieShortDetails) =>
    MovieShortDetailsCM(
      id: movieShortDetails.id,
      title: movieShortDetails.title,
      posterUrl: movieShortDetails.posterUrl,
    );
