import 'package:dio/dio.dart';

import '../model/model.dart';

class RemoteDataSource {
  static const String _baseUrl =
      'https://desafio-mobile.nyc3.digitaloceanspaces.com/movies';

  final Dio _dio = Dio();

  Future<List<MovieShortDetailsRM>> getMovies() async {
    final response = await _dio.get(_baseUrl);

    return response.data
        .map<MovieShortDetailsRM>(
            (movie) => MovieShortDetailsRM.fromJson(movie))
        .toList();
  }

  Future<MovieLongDetailsRM> getMovieDetails(int id) async {
    final response = await _dio.get('$_baseUrl/$id');

    return MovieLongDetailsRM.fromJson(response.data);
  }
}
