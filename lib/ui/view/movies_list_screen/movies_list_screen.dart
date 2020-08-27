import 'package:flutter/material.dart';

import '../../../data/dio/dio_client.dart';
import '../../../data/model/model.dart';

import 'components/movies_content_body.dart';

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
            MoviesContentBody(
              error: _error,
              moviesList: _moviesList,
              awaitingMoviesList: _awaitingMoviesList,
              onTryAgainTap: () {
                _getMovies();
              },
            ),
          ],
        ),
      );
}
