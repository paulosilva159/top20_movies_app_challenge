import 'package:flutter/material.dart';

import '../../../data/dio/dio_client.dart';
import '../../../data/model/model.dart';

import '../../../ui/components/app_flow.dart';

import 'components/movies_content_body.dart';

class MoviesHomeScreen extends StatefulWidget {
  @override
  _MoviesHomeScreenState createState() => _MoviesHomeScreenState();
}

class _MoviesHomeScreenState extends State<MoviesHomeScreen> {
  List<MovieShortDetails> _moviesList;
  bool _awaitingMoviesList;

  final List<AppFlow> appFlows = [
    AppFlow(
      title: 'List',
      iconData: Icons.list,
      mainColor: Colors.amber,
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
    AppFlow(
      title: 'Grid',
      iconData: Icons.grid_on,
      mainColor: Colors.pinkAccent,
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
  ];

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
