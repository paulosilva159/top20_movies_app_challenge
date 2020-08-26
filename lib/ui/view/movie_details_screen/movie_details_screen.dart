import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/dio/dio_client.dart';
import '../../../data/model/model.dart';

import 'components/movie_details_tile.dart';

class MovieDetailsScreen extends StatefulWidget {
  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  MovieLongDetails _movieDetails;
  bool _awaitingMovieDetails;
  int _id;

  dynamic _error;
  final _dio = DioClient();

  void _getMovieDetails() {
    setState(() {
      _error = null;
      _awaitingMovieDetails = true;
    });

    _dio.getMovieDetails(_id).then((movieDetails) {
      setState(() {
        _movieDetails = movieDetails;
        _awaitingMovieDetails = false;
      });
    }).catchError((error) {
      setState(() {
        _error = error.error;
        _awaitingMovieDetails = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (_id == null) {
      _id = ModalRoute.of(context).settings.arguments;

      _getMovieDetails();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes'),
          centerTitle: true,
        ),
        body: _MovieDetailsBody(
          error: _error,
          movieDetails: _movieDetails,
          awaitingMovieDetails: _awaitingMovieDetails,
          getMovieDetails: () {
            _getMovieDetails();
          },
        ),
      );
}

class _MovieDetailsBody extends StatelessWidget {
  const _MovieDetailsBody(
      {@required this.error,
      @required this.movieDetails,
      @required this.awaitingMovieDetails,
      @required this.getMovieDetails})
      : assert(awaitingMovieDetails != null),
        assert(getMovieDetails != null);

  final dynamic error;
  final MovieLongDetails movieDetails;
  final bool awaitingMovieDetails;
  final VoidCallback getMovieDetails;

  @override
  Widget build(BuildContext context) {
    if (awaitingMovieDetails) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (error != null) {
      return Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            if (error is SocketException)
              const Text(
                'Verifique sua conexão',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              )
            else
              const Text(
                'Erro!',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            RaisedButton(
              onPressed: getMovieDetails,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    } else {
      return MovieDetailsTile(movieDetails: movieDetails);
    }
  }
}
