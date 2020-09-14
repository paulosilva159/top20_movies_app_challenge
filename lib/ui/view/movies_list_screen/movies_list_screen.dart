import 'package:flutter/material.dart';
import 'package:tokenlab_challenge/ui/components/asyncsnapshot_response_view.dart';
import 'package:tokenlab_challenge/ui/components/indicators/error_indicator.dart';
import 'package:tokenlab_challenge/ui/components/indicators/loading_indicator.dart';
import 'package:tokenlab_challenge/ui/view/movies_list_screen/movie_list_structure.dart';
import 'package:tokenlab_challenge/ui/view/movies_list_screen/movies_list_screen_state.dart';

import '../../../bloc/movies_list_bloc.dart';

import '../../../routes/routes.dart';

import '../../../ui/components/movies_structure_type.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({
    @required this.movieStructureType,
    Key key,
  })  : assert(movieStructureType != null),
        super(key: key);

  final MovieStructureType movieStructureType;

  @override
  _MoviesListScreenState createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  final _bloc = MoviesListBloc();

  @override
  Widget build(BuildContext context) => StreamBuilder<Object>(
        stream: _bloc.onNewState,
        builder: (context, snapshot) => Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(Routes.favorites);
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
              AsyncSnapshotResponseView<Loading, Error, Success>(
                snapshot: snapshot,
                successWidgetBuilder: (context, snapshot) =>
                    MoviesListStructure(
                  movieStructureType: widget.movieStructureType,
                  moviesList: snapshot.movieList,
                ),
                errorWidgetBuilder: (context, snapshot) => SliverFillRemaining(
                  child: ErrorIndicator(
                    error: snapshot.error,
                    onTryAgainTap: () => _bloc.onTryAgain.add(null),
                  ),
                ),
                loadingWidgetBuilder: (context, snapshot) =>
                    SliverFillRemaining(
                  child: LoadingIndicator(),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
