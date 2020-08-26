import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/dio/dio_client.dart';
import '../../../data/model/model.dart';

import 'components/movies_list.dart';

class MoviesListScreen extends StatefulWidget {
  @override
  _MoviesListScreenState createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  List<MovieShortDetails> _moviesList;
  bool _awaitingMoviesList;

  final _dio = DioClient();
  dynamic _error;

  void _getMovies() {
    setState(() {
      _error = null;
      _awaitingMoviesList = true;
    });

    _dio.getMovies().then((movieList) {
      setState(() {
        _moviesList = movieList;
        _awaitingMoviesList = false;
      });
    }).catchError((error) {
      setState(() {
        _error = error.error;
        _awaitingMoviesList = false;
      });
    });
  }

  @override
  void initState() {
    _getMovies();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('TMDb'),
              centerTitle: true,
              background: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset('lib/ui/assets/top-20.png'),
              ),
            ),
          ),
          _MoviesListBody(
            error: _error,
            moviesList: _moviesList,
            awaitingMoviesList: _awaitingMoviesList,
            getMovies: () {
              _getMovies();
            },
          ),
        ],
      ));
}

class _MoviesListBody extends StatelessWidget {
  const _MoviesListBody({
    @required this.awaitingMoviesList,
    @required this.getMovies,
    this.error,
    this.moviesList,
  })  : assert(awaitingMoviesList != null),
        assert(getMovies != null);

  final dynamic error;
  final List<MovieShortDetails> moviesList;
  final bool awaitingMoviesList;
  final VoidCallback getMovies;

  @override
  Widget build(BuildContext context) {
    if (awaitingMoviesList) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (error != null) {
      return SliverFillRemaining(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            RaisedButton(
              onPressed: getMovies,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    } else {
      return MoviesList(moviesList: moviesList);
    }
  }
}
