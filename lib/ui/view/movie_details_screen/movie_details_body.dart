import 'dart:io';

import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

import 'movie_details_screen_state.dart';
import 'movie_details_tile.dart';

class MovieDetailsBody extends StatelessWidget {
  const MovieDetailsBody({
    @required this.movieDetailsBodyState,
    @required this.getMovieDetails,
  })  : assert(movieDetailsBodyState != null),
        assert(getMovieDetails != null);

  final AsyncSnapshot movieDetailsBodyState;
  final VoidCallback getMovieDetails;

  @override
  Widget build(BuildContext context) {
    if (movieDetailsBodyState.data == null ||
        movieDetailsBodyState.data is Loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (movieDetailsBodyState.data is Error) {
      return Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            if (movieDetailsBodyState.data.error is SocketException)
              Text(
                S.of(context).connectionErrorMessage,
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              )
            else
              Text(
                S.of(context).genericErrorMessage,
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            RaisedButton(
              onPressed: getMovieDetails,
              child: Text(S.of(context).tryAgainMessage),
            ),
          ],
        ),
      );
    } else {
      return MovieDetailsTile(
        movieDetails: movieDetailsBodyState.data.movieDetails,
      );
    }
  }
}
