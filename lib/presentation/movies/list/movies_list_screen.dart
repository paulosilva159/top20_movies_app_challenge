import 'package:domain/use_case/favorite_movie_uc.dart';
import 'package:domain/use_case/get_movies_list_uc.dart';
import 'package:domain/use_case/unfavorite_movie_uc.dart';
import 'package:flutter/material.dart';

import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';
import 'package:tokenlab_challenge/presentation/common/action_stream_listener.dart';
import 'package:tokenlab_challenge/presentation/common/alert_dialogs/states_alert_dialog.dart';
import 'package:tokenlab_challenge/presentation/common/assets_builder.dart';

import 'package:tokenlab_challenge/presentation/common/async_snapshot_response_view.dart';
import 'package:tokenlab_challenge/presentation/common/image_loader.dart';
import 'package:tokenlab_challenge/presentation/common/indicators/indicators.dart';
import 'package:tokenlab_challenge/presentation/common/movies_structure_type.dart';
import 'package:tokenlab_challenge/presentation/common/page_navigation.dart';
import 'package:tokenlab_challenge/presentation/common/routes.dart';

import 'package:domain/model/model.dart';

import 'movies_list_bloc.dart';
import 'movies_list_screen_models.dart';

class MoviesListScreen extends StatelessWidget {
  MoviesListScreen({
    @required this.movieStructureType,
    @required this.bloc,
  })  : assert(movieStructureType != null),
        assert(bloc != null);

  final MovieStructureType movieStructureType;
  final MoviesListBloc bloc;

  final _focusDetectorKey = UniqueKey();

  static Widget create(MovieStructureType movieStructureType) => ProxyProvider3<
          GetMoviesListUC, FavoriteMovieUC, UnfavoriteMovieUC, MoviesListBloc>(
        update: (context, getMoviesList, favoriteMovie, unfavoriteMovie,
                moviesListBloc) =>
            moviesListBloc ??
            MoviesListBloc(
                getMoviesList: getMoviesList,
                favoriteMovie: favoriteMovie,
                unfavoriteMovie: unfavoriteMovie),
        dispose: (context, bloc) => bloc.dispose(),
        child: Consumer<MoviesListBloc>(
          builder: (context, bloc, child) => MoviesListScreen(
              bloc: bloc, movieStructureType: movieStructureType),
        ),
      );

  @override
  Widget build(BuildContext context) => FocusDetector(
        key: _focusDetectorKey,
        onFocusGained: () => bloc.onFocusGain.add(null),
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
                    child: Image.asset(
                      AssetsBuilder.top20Image,
                    ),
                  ),
                ),
              ),
              ActionStreamListener(
                actionStream: bloc.onNewAction,
                onReceived: (event) {
                  if (event is ShowFavoriteTogglingError) {
                    errorAlertDialog(context);
                  } else if (event is ShowFavoriteTogglingSuccess) {
                    successAlertDialog(
                        context, event.title, event.isToFavorite);
                  }
                },
                child: StreamBuilder(
                  stream: bloc.onNewState,
                  builder: (context, snapshot) =>
                      AsyncSnapshotResponseView<Loading, Error, Success>(
                    snapshot: snapshot,
                    successWidgetBuilder: (context, snapshot) =>
                        _MoviesListStructure(
                      onFavoriteTap: bloc.onFavoriteTap.add,
                      movieStructureType: movieStructureType,
                      moviesList: snapshot.moviesList,
                    ),
                    errorWidgetBuilder: (context, snapshot) =>
                        SliverFillRemaining(
                      child: ErrorIndicator(
                        type: snapshot.type,
                        onTryAgainTap: () => bloc.onTryAgain.add(null),
                      ),
                    ),
                    loadingWidgetBuilder: (context, snapshot) =>
                        SliverFillRemaining(
                      child: LoadingIndicator(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}

typedef MovieShortDetailsCallback = void Function(MovieShortDetails);

class _MoviesListStructure extends StatelessWidget {
  const _MoviesListStructure({
    @required this.moviesList,
    @required this.movieStructureType,
    @required this.onFavoriteTap,
  })  : assert(moviesList != null),
        assert(movieStructureType != null),
        assert(onFavoriteTap != null);

  final MovieShortDetailsCallback onFavoriteTap;
  final List<MovieShortDetails> moviesList;
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
                  isFavorite: moviesList[index].isFavorite,
                  onFavoriteTap: () => onFavoriteTap(moviesList[index]),
                ),
              ),
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
