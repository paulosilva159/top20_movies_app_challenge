import 'package:flutter/material.dart';

import 'package:tokenlab_challenge/generated/l10n.dart';

import 'package:tokenlab_challenge/ui/components/indicators/favorite_indicator.dart';

class MovieDetailsTile extends StatelessWidget {
  const MovieDetailsTile({@required this.movieDetails})
      : assert(movieDetails != null);

  final dynamic movieDetails;

  @override
  Widget build(BuildContext context) => ListView(
        children: [
          FavoriteIndicator(
            movieId: movieDetails.id,
            movieName: movieDetails.title,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text('${movieDetails.title} #${movieDetails.id}'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
            child: Text(
              movieDetails.tagline,
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RichText(
                text: TextSpan(
                  text:
                      S.of(context).detailsTileScore(movieDetails.voteAverage),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              RichText(
                text: TextSpan(
                  text:
                      S.of(context).detailsTileVotesQtt(movieDetails.voteCount),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Text(
              movieDetails.overview,
            ),
          ),
        ],
      );
}
