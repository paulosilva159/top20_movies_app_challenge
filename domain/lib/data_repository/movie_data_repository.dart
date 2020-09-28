import 'dart:async';

import 'package:domain/model/model.dart';

abstract class MoviesDataRepository {
  const MoviesDataRepository();

  Future<List<MovieShortDetails>> getMoviesList();

  Future<List<MovieShortDetails>> getFavoritesList();

  Future<MovieLongDetails> getMovieDetails(int movieId);

  Future<void> favoriteMovie(int movieId);

  Future<void> unfavoriteMovie(int movieId);
}
