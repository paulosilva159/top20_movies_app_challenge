import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import 'package:tokenlab_challenge/data/remote/infrastucture/url_builder.dart';
import 'package:tokenlab_challenge/data/remote/model/remote_model.dart';

class MoviesRemoteDataSource {
  MoviesRemoteDataSource({@required this.dio}) : assert(dio != null);

  final Dio dio;

  Future<List<MovieShortDetailsRM>> getMoviesList() =>
      dio.get(PathBuilder.movieList()).then(
            (response) => response.data
                .map<MovieShortDetailsRM>(
                    (movie) => MovieShortDetailsRM.fromJson(movie))
                .toList(),
          );

  Future<MovieLongDetailsRM> getMovieDetails(int movieId) =>
      dio.get(PathBuilder.movie(movieId)).then(
            (response) => MovieLongDetailsRM.fromJson(response.data),
          );
}
