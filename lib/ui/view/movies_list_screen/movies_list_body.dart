import 'package:flutter/material.dart';

import '../../../ui/components/indicators/indicators.dart';
import '../../../ui/components/movies_structure_type.dart';

import 'movie_list_structure.dart';
import 'movies_list_screen_state.dart';

class MoviesListBody extends StatelessWidget {
  const MoviesListBody({
    @required this.moviesListScreenState,
    @required this.movieStructureType,
    @required this.onTryAgainTap,
  })  : assert(moviesListScreenState != null),
        assert(movieStructureType != null),
        assert(onTryAgainTap != null);

  final AsyncSnapshot moviesListScreenState;
  final MovieStructureType movieStructureType;
  final VoidCallback onTryAgainTap;

  @override
  Widget build(BuildContext context) {
    final stateData = moviesListScreenState.data;

    if (stateData == null || stateData is Loading) {
      return SliverFillRemaining(child: LoadingIndicator());
    } else if (stateData is Error) {
      return SliverFillRemaining(
        child: ErrorIndicator(
          error: stateData.error,
          onTryAgainTap: onTryAgainTap,
        ),
      );
    } else if (stateData is Success) {
      return MoviesListStructure(
        moviesList: stateData.movieList,
        movieStructureType: movieStructureType,
      );
    }

    throw Exception();
  }
}
