import 'dart:async';

import '../model/model.dart';

abstract class MovieDataRepository {
  const MovieDataRepository();

  Future<List<MovieShortDetails>> getMoviesList();

  Future<List<MovieShortDetails>> getFavoritesList();

  Future<MovieLongDetails> getMovieDetails(int movieId);

  Future<void> favoriteMovie(int movieId);

  Future<void> unfavoriteMovie(int movieId);
}
