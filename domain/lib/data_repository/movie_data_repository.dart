import '../model/movie_long_details.dart';
import '../model/movie_short_details.dart';

abstract class MovieDataRepository {
  const MovieDataRepository();

  Future<List<MovieShortDetails>> getMoviesList();

  Future<MovieLongDetails> getMovieDetails(int movieId);

  Future<List<int>> getFavoritesMoviesId();

  Future<void> favoriteMovie(int movieId);

  Future<void> unfavoriteMovie(int movieId);
}
