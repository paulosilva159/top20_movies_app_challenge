import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import 'package:tokenlab_challenge/data/model/model.dart';

class MoviesRemoteDataSource {
  MoviesRemoteDataSource({@required this.dio}) : assert(dio != null);

  static const String _baseUrl =
      'https://desafio-mobile.nyc3.digitaloceanspaces.com/movies';

  final Dio dio;

  Future<List<MovieShortDetailsRM>> getMoviesList() async {
    final response = await dio.get(_baseUrl);

    return response.data
        .map<MovieShortDetailsRM>(
            (movie) => MovieShortDetailsRM.fromJson(movie))
        .toList();
  }

  Future<MovieLongDetailsRM> getMovieDetails(int movieId) async {
    final response = await dio.get('$_baseUrl/$movieId');

    return MovieLongDetailsRM.fromJson(response.data);
  }
}
