import 'package:hive/hive.dart';

import '../model/model.dart';

class CacheDataSource {
  final String moviesListBoxName = 'moviesListBox';
  final String movieDetailsBoxName = 'movieDetailsBox';
  final String favoritesBoxName = 'favoritesBox';

  Future<List<MovieShortDetailsCM>> getMoviesList() =>
      Hive.openBox<List>(moviesListBoxName)
          .then((box) => List<MovieShortDetailsCM>.from(box.getAt(0)));

  Future<List<int>> getFavorites() => Hive.openBox<int>(favoritesBoxName)
      .then((box) => List<int>.from(box.keys));

  Future<MovieLongDetailsCM> getMovieDetails(int movieId) =>
      Hive.openBox<MovieLongDetailsCM>(movieDetailsBoxName)
          .then((box) => box.getAt(movieId));

  Future<void> saveMoviesList(List<MovieShortDetailsCM> moviesList) =>
      Hive.isBoxOpen(moviesListBoxName)
          ? Hive.box<List>(moviesListBoxName).putAll({0: moviesList})
          : Hive.openBox<List>(moviesListBoxName)
              .then((box) => box.putAll({0: moviesList}));

  Future<void> saveFavoriteMovieId(int favoriteMovieId) =>
      Hive.isBoxOpen(favoritesBoxName)
          ? Hive.box<int>(favoritesBoxName)
              .put(favoriteMovieId, favoriteMovieId)
          : Hive.openBox<int>(favoritesBoxName)
              .then((box) => box.put(favoriteMovieId, favoriteMovieId));

  Future<void> saveMovieDetails(MovieLongDetailsCM movieDetails) =>
      Hive.isBoxOpen(movieDetailsBoxName)
          ? Hive.box<MovieLongDetailsCM>(movieDetailsBoxName)
              .putAll({movieDetails.id: movieDetails})
          : Hive.openBox<MovieLongDetailsCM>(movieDetailsBoxName)
              .then((box) => box.putAll({movieDetails.id: movieDetails}));

  Future<void> removeFavoriteMovieId(int favoriteMovieId) =>
      Hive.isBoxOpen(favoritesBoxName)
          ? Hive.box<int>(favoritesBoxName).delete(favoriteMovieId)
          : Hive.openBox<int>(favoritesBoxName)
              .then((box) => box.delete(favoriteMovieId));
}
