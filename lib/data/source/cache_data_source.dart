import 'package:hive/hive.dart';

import 'package:tokenlab_challenge/data/model/model.dart';

class MoviesCacheDataSource {
  final String moviesListBoxName = 'moviesListBox';
  final String movieDetailsBoxName = 'movieDetailsBox';
  final String favoritesBoxName = 'favoritesBox';

  Future<List<MovieShortDetailsCM>> getMoviesList() =>
      Hive.openBox<List>(moviesListBoxName)
          .then((box) => List<MovieShortDetailsCM>.from(box.getAt(0)));

  Future<MovieLongDetailsCM> getMovieDetails(int movieId) =>
      Hive.openBox<MovieLongDetailsCM>(movieDetailsBoxName)
          .then((box) => box.getAt(movieId));

  Future<List<int>> getFavorites() => Hive.openBox<String>(favoritesBoxName)
      .then((box) => List<int>.from(box.keys));

  Future<void> upsertMoviesList(List<MovieShortDetailsCM> moviesList) =>
      Hive.openBox<List>(moviesListBoxName)
          .then((box) => box.put(0, moviesList));

  Future<void> upsertMovieDetails(MovieLongDetailsCM movieDetails) =>
      Hive.openBox<MovieLongDetailsCM>(movieDetailsBoxName)
          .then((box) => box.put(movieDetails.id, movieDetails));

  Future<void> upsertFavoriteMovieId(int favoriteMovieId) =>
      Hive.openBox<int>(favoritesBoxName)
          .then((box) => box.put(favoriteMovieId, favoriteMovieId));

  Future<void> removeMoviesList() =>
      Hive.openBox<List>(moviesListBoxName).then((box) => box.deleteAt(0));

  Future<void> removeMovieDetails(MovieLongDetailsCM movieDetails) =>
      Hive.openBox<MovieLongDetailsCM>(movieDetailsBoxName)
          .then((box) => box.deleteAt(movieDetails.id));

  Future<void> removeFavoriteMovieId(int favoriteMovieId) =>
      Hive.openBox<String>(favoritesBoxName)
          .then((box) => box.delete(favoriteMovieId));
}
