import 'package:flutter/material.dart';

import '../../../bloc/movie_details_bloc.dart';

import '../../../generated/l10n.dart';

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
  MovieDetailsBloc _bloc;

  @override
  void initState() {
    _bloc = MovieDetailsBloc(movieId: widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: _bloc.onNewState,
        builder: (context, snapshot) => Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).detailsScreenTopTitle),
            centerTitle: true,
          ),
          body: MovieDetailsBody(
              movieDetailsBodyState: snapshot,
              onTryAgainTap: () => _bloc.onTryAgain.add(null)),
        ),
      );

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
