import 'package:meta/meta.dart';

import 'package:domain/data_repository/movie_data_repository.dart';

import 'package:tokenlab_challenge/data/cache/data_source/movies_cache_data_source.dart';
import 'package:tokenlab_challenge/data/cache/model/movies_cache_model.dart';
import 'package:tokenlab_challenge/data/remote/data_source/movies_remote_data_source.dart';
import 'package:tokenlab_challenge/data/mapper/remote_to_cache.dart';
import 'package:tokenlab_challenge/data/mapper/cache_to_domain.dart';

import 'package:domain/model/model.dart';

class MoviesRepository extends MoviesDataRepository {
  MoviesRepository(
      {@required this.remoteDataSource, @required this.cacheDataSource})
      : assert(remoteDataSource != null),
        assert(cacheDataSource != null);

  final MoviesRemoteDataSource remoteDataSource;
  final MoviesCacheDataSource cacheDataSource;

  @override
  Future<MovieLongDetails> getMovieDetails(int movieId) => Future.wait([
        cacheDataSource.getFavorites(),
        _getMovieDetailsCacheModel(movieId),
      ]).then((futures) {
        final List<int> favoritesIdList = futures[0];
        final MovieLongDetailsCM movie = futures[1];

        return movie.toDomainModel(favoritesIdList.contains(movieId));
      });

  Future<MovieLongDetailsCM> _getMovieDetailsCacheModel(int movieId) =>
      cacheDataSource.getMovieDetails(movieId).catchError((error) =>
          remoteDataSource
              .getMovieDetails(movieId)
              .then((movie) => movie.toCacheModel())
              .then(
                (movie) => _upsertMovieDetails(movie).then((_) => movie),
              ));

  // Future<MovieLongDetails> getMovieDetails2(int movieId) =>
  //     cacheDataSource.getFavorites().then(
  //           (favoritesIdList) => remoteDataSource
  //               .getMovieDetails(movieId)
  //               .then(
  //                 (movie) => _upsertMovieDetails(
  //                   movie.toCacheModel(),
  //                 ).then(
  //                   (_) => movie.toCacheModel(),
  //                 ),
  //               )
  //               .then(
  //                 (cacheModel) => cacheModel.toDomainModel(
  //                   favoritesIdList.contains(movieId),
  //                 ),
  //               )
  //               .catchError(
  //                 (error) => cacheDataSource.getMovieDetails(movieId).then(
  //                       (movie) => movie.toDomainModel(
  //                         favoritesIdList.contains(movieId),
  //                       ),
  //                     ),
  //               ),
  //         );
  //
  // Future<MovieLongDetails> getMovieDetails3(int movieId) async {
  //   MovieLongDetailsCM movieDetails;
  //
  //   try {
  //     movieDetails = await cacheDataSource.getMovieDetails(movieId);
  //   } catch (error) {
  //     movieDetails =
  //         (await remoteDataSource.getMovieDetails(movieId)).toCacheModel();
  //
  //     await _upsertMovieDetails(movieDetails);
  //   }
  //
  //   return movieDetails.toDomainModel(
  //       (await cacheDataSource.getFavorites()).contains(movieId));
  // }
  //
  // Future<MovieLongDetails> getMovieDetails4(int movieId) async {
  //   MovieLongDetailsCM movieDetails;
  //
  //   try {
  //     movieDetails =
  //         (await remoteDataSource.getMovieDetails(movieId)).toCacheModel();
  //
  //     await _upsertMovieDetails(movieDetails);
  //   } catch (error) {
  //     movieDetails = await cacheDataSource.getMovieDetails(movieId);
  //   }
  //
  //   return movieDetails.toDomainModel(
  //       (await cacheDataSource.getFavorites()).contains(movieId));
  // }

  @override
  Future<List<MovieShortDetails>> getMoviesList() => Future.wait([
        cacheDataSource.getFavorites(),
        _getMoviesListCacheModel(),
      ]).then((futures) {
        final List<int> favoritesIdList = futures[0];
        final List<MovieShortDetailsCM> moviesList = futures[1];

        return moviesList
            .map(
              (movie) =>
                  movie.toDomainModel(favoritesIdList.contains(movie.id)),
            )
            .toList();
      });

  Future<List<MovieShortDetailsCM>> _getMoviesListCacheModel() =>
      cacheDataSource.getMoviesList().catchError(
            (error) => remoteDataSource
                .getMoviesList()
                .then((movies) =>
                    movies.map((movie) => movie.toCacheModel()).toList())
                .then(
                  (movies) => _upsertMoviesList(movies).then((_) => movies),
                ),
          );

  // Future<List<MovieShortDetails>> getMoviesList2() => cacheDataSource
  //     .getFavorites()
  //     .then(
  //       (favoritesIdList) => remoteDataSource
  //           .getMoviesList()
  //           .then(
  //             (movies) => _upsertMoviesList(
  //                     movies.map((movie) => movie.toCacheModel()).toList())
  //                 .then(
  //               (_) => movies.map((movie) => movie.toCacheModel()).toList(),
  //             ),
  //           )
  //           .then(
  //             (movies) => movies
  //                 .map(
  //                   (movie) =>
  //                    movie.toDomainModel(favoritesIdList.contains(movie.id)),
  //                 )
  //                 .toList(),
  //           )
  //           .catchError((error) => cacheDataSource.getMoviesList().then(
  //                 (movies) => movies
  //                     .map(
  //                       (movie) => movie
  //                         .toDomainModel(favoritesIdList.contains(movie.id)),
  //                     )
  //                     .toList(),
  //               )),
  //     );
  //
  // Future<List<MovieShortDetails>> getMoviesList3() async {
  //   List<MovieShortDetailsCM> moviesList;
  //   final favoritesIdList = await cacheDataSource.getFavorites();
  //
  //   try {
  //     moviesList = await cacheDataSource.getMoviesList();
  //   } catch (error) {
  //     moviesList = (await remoteDataSource.getMoviesList())
  //         .map(
  //           (movie) => movie.toCacheModel(),
  //         )
  //         .toList();
  //
  //     await _upsertMoviesList(moviesList);
  //   }
  //
  //   return moviesList.map(
  //     (movie) => movie.toDomainModel(
  //       favoritesIdList.contains(movie.id),
  //     ),
  //   );
  // }
  //
  // Future<List<MovieShortDetails>> getMoviesList4() async {
  //   List<MovieShortDetailsCM> moviesList;
  //   final favoritesIdList = await cacheDataSource.getFavorites();
  //
  //   try {
  //     moviesList = (await remoteDataSource.getMoviesList())
  //         .map(
  //           (movie) => movie.toCacheModel(),
  //         )
  //         .toList();
  //
  //     await _upsertMoviesList(moviesList);
  //   } catch (error) {
  //     moviesList = await cacheDataSource.getMoviesList();
  //   }
  //
  //   return moviesList.map(
  //     (movie) => movie.toDomainModel(
  //       favoritesIdList.contains(movie.id),
  //     ),
  //   );
  // }

  @override
  Future<List<MovieShortDetails>> getFavoritesList() => Future.wait([
        cacheDataSource.getFavorites(),
        cacheDataSource.getMoviesList(),
      ]).then(
        (futureList) {
          final List<int> favoritesId = futureList[0];
          final List<MovieShortDetailsCM> moviesList = futureList[1];

          return moviesList
              .where((movie) => favoritesId.contains(movie.id))
              .map((movie) => movie.toDomainModel(
                    favoritesId.contains(movie.id),
                  ))
              .toList();
        },
      ).catchError((error) => <MovieShortDetails>[]);

  @override
  Future<void> favoriteMovie(int movieId) =>
      cacheDataSource.upsertFavoriteMovieId(movieId);

  // @override
  // Future<void> favoriteMovie(int movieId) => throw Error();

  @override
  Future<void> unfavoriteMovie(int movieId) =>
      cacheDataSource.removeFavoriteMovieId(movieId);

  Future<void> _upsertMoviesList(List<MovieShortDetailsCM> moviesList) =>
      cacheDataSource.upsertMoviesList(moviesList);

  Future<void> _upsertMovieDetails(MovieLongDetailsCM movieDetails) =>
      cacheDataSource.upsertMovieDetails(movieDetails);
}
