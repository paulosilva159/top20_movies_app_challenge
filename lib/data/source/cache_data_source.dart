import 'package:hive/hive.dart';

import 'package:tokenlab_challenge/data/model/model.dart';

class MoviesCacheDataSource {
  final String moviesListBoxName = 'moviesListBox';
  final String movieDetailsBoxName = 'movieDetailsBox';
  final String favoritesBoxName = 'favoritesBox';

  Future<List<MovieShortDetailsCM>> getMoviesList() =>
      Hive.openBox(moviesListBoxName)
          .then((box) => List<MovieShortDetailsCM>.from(box.getAt(0)));

  Future<MovieLongDetailsCM> getMovieDetails(int movieId) =>
      Hive.openBox(movieDetailsBoxName).then((box) => box.getAt(movieId));

  Future<List<int>> getFavorites() =>
      Hive.openBox(favoritesBoxName).then((box) => List<int>.from(box.values));

  Future<void> upsertMoviesList(List<MovieShortDetailsCM> moviesList) =>
      Hive.openBox(moviesListBoxName).then((box) => box.add(moviesList));

  Future<void> upsertMovieDetails(MovieLongDetailsCM movieDetails) =>
      Hive.openBox(movieDetailsBoxName)
          .then((box) => box.put(movieDetails.id, movieDetails));

  Future<void> upsertFavoriteMovieId(int favoriteMovieId) =>
      Hive.openBox(favoritesBoxName).then((box) => box.add(favoriteMovieId));

  Future<void> removeMoviesList() =>
      Hive.openBox(moviesListBoxName).then((box) => box.deleteAt(0));

  Future<void> removeMovieDetails(MovieLongDetailsCM movieDetails) =>
      Hive.openBox(movieDetailsBoxName)
          .then((box) => box.deleteAt(movieDetails.id));

  Future<void> removeFavoriteMovieId(int favoriteMovieId) =>
      Hive.openBox(favoritesBoxName).then(
          (box) => box.delete(box.values.toList().indexOf(favoriteMovieId)));
}
