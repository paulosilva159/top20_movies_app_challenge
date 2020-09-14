import 'package:flutter/material.dart';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:focus_detector/focus_detector.dart';

import 'package:tokenlab_challenge/bloc/movies_list_bloc.dart';

import 'package:tokenlab_challenge/routes/routes.dart';

import 'package:tokenlab_challenge/ui/components/movies_structure_type.dart';

import 'movies_list_body.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({
    @required this.movieStructureType,
    Key key,
  })  : assert(movieStructureType != null),
        super(key: key);

  final String movieStructureType;

  @override
  _MoviesListScreenState createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  final _bloc = MoviesListBloc();
  final _focusDetectorKey = UniqueKey();

  @override
  Widget build(BuildContext context) => FocusDetector(
        key: _focusDetectorKey,
        onFocusGained: () => _bloc.onFocusChange.add(null),
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
                stream: _bloc.onNewState,
                builder: (context, snapshot) => MoviesListBody(
                  moviesListScreenSnapshot: snapshot,
                  movieStructureType: widget.movieStructureType ==
                          EnumToString.parse(MovieStructureType.list)
                      ? MovieStructureType.list
                      : MovieStructureType.grid,
                  onTryAgainTap: () => _bloc.onTryAgain.add(null),
                  onFavoriteTapStreamSink: _bloc.onFavoriteTap,
                ),
              )
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
