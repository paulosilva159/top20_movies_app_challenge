import 'package:hive/hive.dart';

import '../model/model.dart';

class CacheDataSource {
  final String moviesListBoxName = 'moviesListBox';
  final String movieDetailsBoxName = 'movieDetailsBox';

  Future<List<MovieShortDetailsCM>> getMoviesList() =>
      Hive.openBox<List>(moviesListBoxName)
          .then((box) => List<MovieShortDetailsCM>.from(box.getAt(0)));

  Future<MovieLongDetailsCM> getMovieDetails(int movieId) =>
      Hive.openBox<MovieLongDetailsCM>(movieDetailsBoxName)
          .then((box) => box.getAt(movieId));

  Future<void> saveMoviesList(List<MovieShortDetailsCM> moviesList) =>
      Hive.isBoxOpen(moviesListBoxName)
          ? Hive.box<List>(moviesListBoxName).putAll({0: moviesList})
          : Hive.openBox<List>(moviesListBoxName)
              .then((box) => box.putAll({0: moviesList}));

  Future<void> saveMovieDetails(MovieLongDetailsCM movieDetails) =>
      Hive.isBoxOpen(movieDetailsBoxName)
          ? Hive.box<MovieLongDetailsCM>(movieDetailsBoxName)
              .putAll({movieDetails.id: movieDetails})
          : Hive.openBox<MovieLongDetailsCM>(movieDetailsBoxName)
              .then((box) => box.putAll({movieDetails.id: movieDetails}));
}
