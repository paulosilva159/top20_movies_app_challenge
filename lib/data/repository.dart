import 'model/model.dart';
import 'source/source.dart';

class Repository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final CacheDataSource _cacheDataSource = CacheDataSource();

  Future getMovieDetails(int movieId) async {
    dynamic movieDetails;

    try {
      movieDetails = await _cacheDataSource.getMovieDetails(movieId);
    } catch (error) {
      if (error is RangeError) {
        movieDetails ??= await _remoteDataSource.getMovieDetails(movieId);
      }

      print(error);
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
      }

      print(error);
    }

    return moviesList;
  }

  void saveMoviesList<T>(List<T> moviesList) {
    assert(T is MovieShortDetailsRM || T is MovieShortDetailsCM);

    _cacheDataSource.saveMoviesList(
      moviesList
          .map<MovieShortDetailsCM>(_movieShortDetailsToCacheModel)
          .toList(),
    );
  }

  void saveMovieDetails<T>(T movieDetails) {
    assert(T is MovieLongDetailsRM || T is MovieLongDetailsCM);

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
}
