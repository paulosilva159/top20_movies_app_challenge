import 'package:dio/dio.dart';

import '../model/model.dart';

class DioClient {
  static const String _baseUrl =
      'https://desafio-mobile.nyc3.digitaloceanspaces.com/movies';

  final Dio _dio = Dio();

  Future<List<MovieShortDetails>> getMovies() async {
    final response = await _dio.get(_baseUrl);

    return response.data
        .map<MovieShortDetails>((movie) => MovieShortDetails.fromJson(movie))
        .toList();
  }

  Future<MovieLongDetails> getMovieDetails(int id) async {
    final response = await _dio.get('$_baseUrl/$id');

    return MovieLongDetails.fromJson(response.data);
  }
}