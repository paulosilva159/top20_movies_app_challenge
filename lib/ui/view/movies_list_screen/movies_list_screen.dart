import 'package:flutter/material.dart';

import 'package:focus_detector/focus_detector.dart';

import 'package:tokenlab_challenge/ui/components/indicators/indicators.dart';
import 'package:tokenlab_challenge/ui/components/movies_structure_type.dart';
import 'package:tokenlab_challenge/ui/components/async_snapshot_response_view.dart';
import 'package:tokenlab_challenge/ui/view/movies_list_screen/movies_list_screen_state.dart';

import 'package:tokenlab_challenge/bloc/movies_list_bloc.dart';

import 'package:tokenlab_challenge/routes/routes.dart';

import 'movies_list_structure.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({
    @required this.movieStructureType,
    @required this.bloc,
  })  : assert(movieStructureType != null),
        assert(bloc != null);

  final MovieStructureType movieStructureType;
  final MoviesListBloc bloc;

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
                      MoviesListStructure(
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
