import 'package:dio/dio.dart';

import '../model/model.dart';

String baseUrl = 'https://desafio-mobile.nyc3.digitaloceanspaces.com/movies';

class DioClient {
  final Dio _dio = Dio();

  Future<List<MovieShortDetails>> getMovies() async {
    final movieList = <MovieShortDetails>[];

    try {
      final response = await _dio.get(baseUrl);

      if (response.statusCode == 200) {
        response.data.forEach((movie) {
          movieList.add(MovieShortDetails.fromJson(movie));
        });
      } else {
        print(
            'We got ${response.statusCode} while trying to obtain the movies');
      }
    } catch (error) {
      print(error);
    }

    return movieList;
  }

  Future<MovieLongDetails> getMovieDetails(int id) async {
    MovieLongDetails movieDetails;

    try {
      final response = await _dio.get('$baseUrl/$id');

      if (response.statusCode == 200) {
        movieDetails = MovieLongDetails.fromJson(response.data);
      } else {
        print(
            'We got ${response.statusCode} while trying to obtain the details');
      }
    } catch (error) {
      print(error);
    }

    return movieDetails;
  }
}
