import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';

import 'package:tokenlab_challenge/ui/components/async_snapshot_response_view.dart';
import 'package:tokenlab_challenge/ui/components/indicators/indicators.dart';
import 'package:tokenlab_challenge/ui/view/movie_details_screen/movie_details_tile.dart';

import 'package:tokenlab_challenge/bloc/movie_details_bloc.dart';

import 'package:tokenlab_challenge/generated/l10n.dart';

import 'movie_details_screen_state.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({@required this.movieId, @required this.bloc})
      : assert(movieId != null),
        assert(bloc != null);

  final int movieId;
  final MovieDetailsBloc bloc;

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final _focusDetectorKey = UniqueKey();
  MovieDetailsBloc bloc;

  @override
  Widget build(BuildContext context) => FocusDetector(
      key: _focusDetectorKey,
      onFocusGained: () => widget.bloc.onFocusGain.add(null),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).detailsScreenTopTitle),
          centerTitle: true,
        ),
        body: StreamBuilder<MovieDetailsBodyState>(
          stream: widget.bloc.onNewState,
          builder: (context, snapshot) =>
              AsyncSnapshotResponseView<Loading, Error, Success>(
            snapshot: snapshot,
            successWidgetBuilder: (context, snapshot) =>
                MovieDetailsTile.create(
                    snapshot.isFavorite, snapshot.movieDetails),
            errorWidgetBuilder: (context, snapshot) => ErrorIndicator(
              error: snapshot.error,
              onTryAgainTap: () => widget.bloc.onTryAgain.add(null),
            ),
            loadingWidgetBuilder: (context, snapshot) => LoadingIndicator(),
          ),
        ),
      ));

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}
