import 'package:flutter/material.dart';

import '../../../ui/components/indicators/error_indicator.dart';
import '../../../ui/components/indicators/loading_indicator.dart';

import 'movie_details_screen_state.dart';
import 'movie_details_tile.dart';

class MovieDetailsBody extends StatelessWidget {
  const MovieDetailsBody({
    @required this.movieDetailsBodyState,
    @required this.onTryAgainTap,
  })  : assert(movieDetailsBodyState != null),
        assert(onTryAgainTap != null);

  final AsyncSnapshot movieDetailsBodyState;
  final VoidCallback onTryAgainTap;

  @override
  Widget build(BuildContext context) {
    final stateData = movieDetailsBodyState.data;

    if (stateData == null || stateData is Loading) {
      return LoadingIndicator();
    } else if (stateData is Error) {
      return ErrorIndicator(
        error: stateData.error,
        onTryAgainTap: onTryAgainTap,
      );
    } else {
      return MovieDetailsTile(
        movieDetails: stateData.movieDetails,
      );
    }
  }
}
