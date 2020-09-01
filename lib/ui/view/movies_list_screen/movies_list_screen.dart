import 'package:flutter/material.dart';

import '../../../data/dio/dio_client.dart';
import '../../../data/model/model.dart';

import '../../../ui/components/movies_structure.dart';
import 'components/movies_list_body.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({Key key, this.movieStructureType}) : super(key: key);

  final MovieStructureType movieStructureType;

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
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed('vertical_example');
                  },
                  icon: const Icon(Icons.vertical_align_top),
                )
              ],
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
              movieStructureType: widget.movieStructureType,
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
