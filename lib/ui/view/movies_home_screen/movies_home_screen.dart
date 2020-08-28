import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/dio/dio_client.dart';
import '../../../data/model/model.dart';

import '../../../ui/components/app_flow.dart';
import '../../../ui/components/bottom_navigator_tab.dart';

import '../../components/bottom_navigation_scaffold/adaptive.dart';

import 'components/movies_content_body.dart';
import 'components/movies_structure.dart';

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
      movieStructureType: MovieStructureType.list,
      iconData: Icons.list,
      mainColor: Colors.amber,
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
    AppFlow(
      title: 'Grid',
      movieStructureType: MovieStructureType.grid,
      iconData: Icons.grid_on,
      mainColor: Colors.pinkAccent,
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
    AppFlow(
      title: 'Vertical',
      movieStructureType: MovieStructureType.vertical,
      iconData: Icons.vertical_align_bottom,
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
  Widget build(BuildContext context) => AdaptiveBottomNavigationScaffold(
        navigationBarItems: appFlows
            .map(
              (flow) => BottomNavigationTab(
                bottomNavigationBarItem: BottomNavigationBarItem(
                  title: Text(flow.title),
                  icon: Icon(flow.iconData),
                ),
                navigatorKey: flow.navigatorKey,
                initialPageBuilder: (context) => Scaffold(
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
                        movieStructureType: flow.movieStructureType,
                        error: _error,
                        moviesList: _moviesList,
                        awaitingMoviesList: _awaitingMoviesList,
                        onTryAgainTap: () {
                          _getMovies();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      );
}
