import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tokenlab_challenge/data/model/cache/cache_model.dart';
import 'package:tokenlab_challenge/data/movies_repository.dart';

import 'package:tokenlab_challenge/generated/l10n.dart';

import 'package:tokenlab_challenge/ui/components/indicators/favorite_indicator.dart';

class MovieDetailsTile extends StatefulWidget {
  const MovieDetailsTile({
    @required this.movieDetails,
    @required this.isFavorite,
    @required this.onFavoriteTap,
  })  : assert(movieDetails != null),
        assert(onFavoriteTap != null),
        assert(isFavorite != null);

  final VoidCallback onFavoriteTap;
  final MovieLongDetailsCM movieDetails;
  final bool isFavorite;

  static Widget create(bool isFavorite, MovieLongDetailsCM movieDetails) =>
      ProxyProvider<MoviesRepository, FavoriteItemBloc>(
        update: (context, moviesRepository, favoriteItemBloc) =>
            FavoriteItemBloc(
                repository: moviesRepository, movieId: movieDetails.id),
        child: Consumer<FavoriteItemBloc>(
          builder: (context, bloc, child) => MovieDetailsTile(
            movieDetails: movieDetails,
            isFavorite: isFavorite,
            bloc: bloc,
          ),
        ),
      );

  @override
  _MovieDetailsTileState createState() => _MovieDetailsTileState();
}

class _MovieDetailsTileState extends State<MovieDetailsTile> {
  @override
  Widget build(BuildContext context) => ListView(
        children: [
          FavoriteIndicator(
              onFavoriteTap: widget.onFavoriteTap,
              isFavorite: widget.isFavorite),
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
    super.dispose();
  }
}
