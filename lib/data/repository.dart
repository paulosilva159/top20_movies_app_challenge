import 'model/model.dart';
import 'source/source.dart';

class Repository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final CacheDataSource _cacheDataSource = CacheDataSource();

  bool hasLoadMovieDetailsFromCache = false;
  bool hasLoadMoviesListFromCache = false;

  Future getMovieDetails(int movieId) async {
    dynamic movieDetails;

    try {
      movieDetails = await _cacheDataSource.getMovieDetails(movieId);
      hasLoadMovieDetailsFromCache = true;
    } catch (error) {
      hasLoadMovieDetailsFromCache = false;
      if (error is RangeError) {
        movieDetails = await _remoteDataSource.getMovieDetails(movieId);
      }

      print(error);
    }

    return movieDetails;
  }

  Future getMoviesList() async {
    dynamic moviesList;

    try {
      moviesList = await _cacheDataSource.getMoviesList();
      hasLoadMoviesListFromCache = true;
    } catch (error) {
      hasLoadMoviesListFromCache = false;
      if (error is RangeError) {
        moviesList = await _remoteDataSource.getMoviesList();
      }
    }

    return moviesList;
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

  Future<List<int>> getFavorite() async {
    List<int> favoritesList;

    try {
      favoritesList = await _cacheDataSource.getFavorites();
    } catch (error) {
      print(error);
    }

    return favoritesList;
  }

  void saveFavoriteMovieId(int movieId) {
    _cacheDataSource.saveFavorites(movieId);
  }
}
