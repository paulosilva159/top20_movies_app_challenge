import 'package:flutter/material.dart';
import 'package:tokenlab_challenge/bloc/favorite_item_bloc.dart';

import 'package:tokenlab_challenge/generated/l10n.dart';

import 'package:tokenlab_challenge/ui/components/indicators/favorite_indicator.dart';

class MovieDetailsTile extends StatefulWidget {
  const MovieDetailsTile({@required this.movieDetails})
      : assert(movieDetails != null);

  final dynamic movieDetails;

  @override
  _MovieDetailsTileState createState() => _MovieDetailsTileState();
}

class _MovieDetailsTileState extends State<MovieDetailsTile> {
  FavoriteItemBloc _bloc;

  @override
  void initState() {
    _bloc = FavoriteItemBloc(
        movieId: widget.movieDetails.id, movieName: widget.movieDetails.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ListView(
        children: [
          StreamBuilder<bool>(
              stream: _bloc.onNewState,
              builder: (context, snapshot) => FavoriteIndicator(
                  onFavoriteTap: () => _bloc.onFavoriteTap.add(null),
                  isFavorite: snapshot.data)),
          Padding(
            padding: const EdgeInsets.all(15),
            child:
                Text('${widget.movieDetails.title} #${widget.movieDetails.id}'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
            child: Text(
              widget.movieDetails.tagline,
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RichText(
                text: TextSpan(
                  text: S
                      .of(context)
                      .detailsTileScore(widget.movieDetails.voteAverage),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: S
                      .of(context)
                      .detailsTileVotesQtt(widget.movieDetails.voteCount),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Text(
              widget.movieDetails.overview,
            ),
          ),
        ],
      );

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
