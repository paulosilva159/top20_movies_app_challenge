import 'package:hive/hive.dart';

import 'package:tokenlab_challenge/data/model/model.dart';

class MoviesCacheDataSource {
  final String _moviesListBoxName = 'moviesListBox';
  final String _movieDetailsBoxName = 'movieDetailsBox';
  final String _favoritesBoxName = 'favoritesBox';

  Future<List<MovieShortDetailsCM>> getMoviesList() =>
      Hive.openBox(_moviesListBoxName).then(
        (box) => List<MovieShortDetailsCM>.from(
          box.getAt(0),
        ),
      );

  Future<MovieLongDetailsCM> getMovieDetails(int movieId) =>
      Hive.openBox(_movieDetailsBoxName).then(
        (box) => box.get(movieId) ?? Exception(),
      );

  Future<List<int>> getFavorites() => Hive.openBox(_favoritesBoxName).then(
        (box) => List<int>.from(box.values),
      );

  Future<void> upsertMoviesList(List<MovieShortDetailsCM> moviesList) =>
      Hive.openBox(_moviesListBoxName).then(
        (box) => box.add(moviesList) ?? Exception(),
      );

  Future<void> upsertMovieDetails(MovieLongDetailsCM movieDetails) =>
      Hive.openBox(_movieDetailsBoxName).then(
        (box) => box.put(movieDetails.id, movieDetails),
      );

  Future<void> upsertFavoriteMovieId(int favoriteMovieId) =>
      Hive.openBox(_favoritesBoxName).then(
        (box) => box.add(favoriteMovieId),
      );

  Future<void> removeFavoriteMovieId(int favoriteMovieId) =>
      Hive.openBox(_favoritesBoxName).then(
        (box) => box.toMap().forEach(
          (key, value) {
            if (value == favoriteMovieId) {
              box.delete(key);
            }
          },
        ),
      );
}

// class NullException implements Exception {}
