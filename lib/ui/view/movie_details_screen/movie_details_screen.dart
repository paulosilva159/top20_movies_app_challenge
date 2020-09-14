import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';

import 'package:tokenlab_challenge/bloc/movie_details_bloc.dart';

import 'package:tokenlab_challenge/generated/l10n.dart';

import 'movie_details_body.dart';

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
            builder: (context, snapshot) => MovieDetailsBody(
              movieDetailsBodyState: snapshot,
              onTryAgainTap: () => _bloc.onTryAgain.add(null),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
