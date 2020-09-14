import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';

import 'package:tokenlab_challenge/ui/components/async_snapshot_response_view.dart';
import 'package:tokenlab_challenge/ui/components/indicators/error_indicator.dart';
import 'package:tokenlab_challenge/ui/components/indicators/loading_indicator.dart';
import 'package:tokenlab_challenge/ui/view/movie_details_screen/movie_details_tile.dart';

import 'package:tokenlab_challenge/bloc/movie_details_bloc.dart';

import 'package:tokenlab_challenge/generated/l10n.dart';

import 'movie_details_screen_state.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({@required this.id, Key key})
      : assert(id != null),
        super(key: key);

  final int id;

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final _focusDetectorKey = UniqueKey();
  MovieDetailsBloc _bloc;

  @override
  void initState() {
    _bloc = MovieDetailsBloc(movieId: widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => FocusDetector(
      key: _focusDetectorKey,
      onFocusGained: () => _bloc.onFocusGain.add(null),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).detailsScreenTopTitle),
          centerTitle: true,
        ),
        body: StreamBuilder<Object>(
          stream: _bloc.onNewState,
          builder: (context, snapshot) =>
              AsyncSnapshotResponseView<Loading, Error, Success>(
            snapshot: snapshot,
            successWidgetBuilder: (context, snapshot) => MovieDetailsTile(
              isFavorite: snapshot.isFavorite,
              movieDetails: snapshot.movieDetails,
            ),
            errorWidgetBuilder: (context, snapshot) => ErrorIndicator(
              error: snapshot.error,
              onTryAgainTap: () => _bloc.onTryAgain.add(null),
            ),
            loadingWidgetBuilder: (context, snapshot) => LoadingIndicator(),
          ),
        ),
      ));

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
