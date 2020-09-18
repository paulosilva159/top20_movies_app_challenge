import 'package:flutter/material.dart';

import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';

import 'package:tokenlab_challenge/data/repository/movies_repository.dart';
import 'package:tokenlab_challenge/data/cache/model/cache_model.dart';

import 'package:tokenlab_challenge/presentation/common/async_snapshot_response_view.dart';
import 'package:tokenlab_challenge/presentation/common/image_loader.dart';
import 'package:tokenlab_challenge/presentation/common/indicators/indicators.dart';
import 'package:tokenlab_challenge/presentation/common/movies_structure_type.dart';
import 'package:tokenlab_challenge/presentation/common/page_navigation.dart';
import 'package:tokenlab_challenge/presentation/common/routes.dart';

import 'movies_list_bloc.dart';
import 'movies_list_screen_state.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({
    @required this.movieStructureType,
    @required this.bloc,
  })  : assert(movieStructureType != null),
        assert(bloc != null);

  final MovieStructureType movieStructureType;
  final MoviesListBloc bloc;

  static Widget create(MovieStructureType movieStructureType) =>
      ProxyProvider<MoviesRepository, MoviesListBloc>(
        update: (context, moviesRepository, moviesListBloc) =>
            MoviesListBloc(repository: moviesRepository),
        child: Consumer<MoviesListBloc>(
          builder: (context, bloc, child) => MoviesListScreen(
              bloc: bloc, movieStructureType: movieStructureType),
        ),
      );

  @override
  _MoviesListScreenState createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  final _focusDetectorKey = UniqueKey();

  @override
  Widget build(BuildContext context) => FocusDetector(
        key: _focusDetectorKey,
        onFocusGained: () => widget.bloc.onFocusGain.add(null),
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(Routes.favorites);
                    },
                    icon: const Icon(Icons.favorite),
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
              StreamBuilder(
                stream: widget.bloc.onNewState,
                builder: (context, snapshot) =>
                    AsyncSnapshotResponseView<Loading, Error, Success>(
                  snapshot: snapshot,
                  successWidgetBuilder: (context, snapshot) =>
                      _MoviesListStructure(
                    onFavoriteTap: widget.bloc.onFavoriteTap.add,
                    movieStructureType: widget.movieStructureType,
                    moviesList: snapshot.moviesList,
                    favoritesList: snapshot.favoritesList,
                  ),
                  errorWidgetBuilder: (context, snapshot) =>
                      SliverFillRemaining(
                    child: ErrorIndicator(
                      error: snapshot.error,
                      onTryAgainTap: () => widget.bloc.onTryAgain.add(null),
                    ),
                  ),
                  loadingWidgetBuilder: (context, snapshot) =>
                      SliverFillRemaining(
                    child: LoadingIndicator(),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}

typedef MovieShortDetailsCallback = void Function(MovieShortDetailsCM);

class _MoviesListStructure extends StatelessWidget {
  const _MoviesListStructure({
    @required this.moviesList,
    @required this.movieStructureType,
    @required this.favoritesList,
    @required this.onFavoriteTap,
  })  : assert(moviesList != null),
        assert(movieStructureType != null),
        assert(favoritesList != null),
        assert(onFavoriteTap != null);

  final List<MovieShortDetailsCM> favoritesList;
  final MovieShortDetailsCallback onFavoriteTap;
  final List<MovieShortDetailsCM> moviesList;
  final MovieStructureType movieStructureType;

  SliverChildBuilderDelegate _buildSliverChildDelegate(BuildContext context) =>
      SliverChildBuilderDelegate(
        (context, index) => FlatButton(
          onPressed: () =>
              pushPage(context, true, arguments: moviesList[index].id),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ImageLoader(
                  title: moviesList[index].title,
                  url: moviesList[index].posterUrl,
                  titleStyle: Theme.of(context).textTheme.headline1,
                ),
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: FavoriteIndicator(
                    isFavorite: favoritesList.contains(moviesList[index]),
                    onFavoriteTap: () => onFavoriteTap(moviesList[index]),
                  )),
            ],
          ),
        ),
        childCount: moviesList.length,
      );

  @override
  Widget build(BuildContext context) =>
      movieStructureType == MovieStructureType.list
          ? SliverList(
              delegate: _buildSliverChildDelegate(context),
            )
          : SliverGrid(
              delegate: _buildSliverChildDelegate(context),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
            );
}
