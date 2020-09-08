import 'package:flutter/material.dart';

import '../../../ui/components/indicators/indicators.dart';
import '../../../ui/components/movies_structure_type.dart';

import 'movies_list_screen_state.dart';
import 'movies_list_structure.dart';

class MoviesListBody extends StatelessWidget {
  const MoviesListBody({
    @required this.moviesListScreenSnapshot,
    @required this.movieStructureType,
    @required this.onTryAgainTap,
  })  : assert(moviesListScreenSnapshot != null),
        assert(movieStructureType != null),
        assert(onTryAgainTap != null);

  final AsyncSnapshot moviesListScreenSnapshot;
  final MovieStructureType movieStructureType;
  final VoidCallback onTryAgainTap;

  @override
  Widget build(BuildContext context) {
    final stateData = moviesListScreenSnapshot.data;

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
        moviesList: stateData.moviesList,
        movieStructureType: movieStructureType,
      );
    }

    throw Exception();
  }
}
