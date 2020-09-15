import 'package:hive/hive.dart';

import 'package:tokenlab_challenge/data/model/model.dart';

class MoviesCacheDataSource {
  static const String _moviesListBoxName = 'moviesListBox';
  static const String _movieDetailsBoxName = 'movieDetailsBox';
  static const String _favoritesBoxName = 'favoritesBox';

  Future<List<MovieShortDetailsCM>> getMoviesList() =>
      Hive.openBox<List>(_moviesListBoxName)
          .then((box) => List<MovieShortDetailsCM>.from(box.getAt(0)));

  Future<MovieLongDetailsCM> getMovieDetails(int movieId) =>
      Hive.openBox<MovieLongDetailsCM>(_movieDetailsBoxName)
          .then((box) => box.getAt(movieId));

  Future<Map<int, String>> getFavorites() =>
      Hive.openBox<String>(_favoritesBoxName)
          .then((box) => Map<int, String>.from(box.toMap()))
          .catchError(print);

  Future<void> upsertMoviesList(List<MovieShortDetailsCM> moviesList) =>
      Hive.openBox<List>(_moviesListBoxName)
          .then((box) => box.put(0, moviesList));

  Future<void> upsertMovieDetails(MovieLongDetailsCM movieDetails) =>
      Hive.openBox<MovieLongDetailsCM>(_movieDetailsBoxName)
          .then((box) => box.put(movieDetails.id, movieDetails));

  Future<void> upsertFavoriteMovieId(
          int favoriteMovieId, String favoriteMovieName) =>
      Hive.openBox<String>(_favoritesBoxName)
          .then((box) => box.put(favoriteMovieId, favoriteMovieName));

  Future<void> removeMoviesList() =>
      Hive.openBox<List>(_moviesListBoxName).then((box) => box.deleteAt(0));

  Future<void> removeMovieDetails(MovieLongDetailsCM movieDetails) =>
      Hive.openBox<MovieLongDetailsCM>(_movieDetailsBoxName)
          .then((box) => box.deleteAt(movieDetails.id));

  Future<void> removeFavoriteMovieId(int favoriteMovieId) =>
      Hive.openBox<String>(_favoritesBoxName)
          .then((box) => box.delete(favoriteMovieId));
}
