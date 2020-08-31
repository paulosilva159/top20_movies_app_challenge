import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/dio/dio_client.dart';
import '../../../data/model/model.dart';

import '../../../generated/l10n.dart';

import '../../../ui/components/app_flow.dart';
import '../../../ui/components/bottom_navigator_tab.dart';
import '../../../ui/components/page_navigation.dart';

import '../../components/bottom_navigation_scaffold/adaptive_bottom_navigation_scaffold.dart';

import 'components/movies_content_body.dart';
import 'components/movies_structure.dart';

class MoviesHomeScreen extends StatefulWidget {
  @override
  _MoviesHomeScreenState createState() => _MoviesHomeScreenState();
}

class _MoviesHomeScreenState extends State<MoviesHomeScreen> {
  List<MovieShortDetails> _moviesList;
  Locale _userLocale;
  bool _awaitingMoviesList;
  List<AppFlow> _appFlows;

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
  void didChangeDependencies() {
    final newLocale = Localizations.localeOf(context);

    if (newLocale != _userLocale) {
      _userLocale = newLocale;

      _appFlows = [
        AppFlow(
          title: S.of(context).bottomNavigationItemListTitle,
          movieStructureType: MovieStructureType.list,
          iconData: Icons.list,
          mainColor: Colors.amber,
          navigatorKey: GlobalKey<NavigatorState>(),
        ),
        AppFlow(
          title: S.of(context).bottomNavigationItemGridTitle,
          movieStructureType: MovieStructureType.grid,
          iconData: Icons.grid_on,
          mainColor: Colors.pinkAccent,
          navigatorKey: GlobalKey<NavigatorState>(),
        ),
      ];
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => AdaptiveBottomNavigationScaffold(
        key: GlobalKey(),
        navigationBarItems: _appFlows
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
                        actions: [
                          IconButton(
                            onPressed: () {
                              pushPage(context, false);
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
