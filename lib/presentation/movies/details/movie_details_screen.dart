import 'package:domain/use_case/favorite_movie_uc.dart';
import 'package:domain/use_case/get_movie_details_uc.dart';
import 'package:domain/use_case/unfavorite_movie_uc.dart';
import 'package:flutter/material.dart';

import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';

import 'package:tokenlab_challenge/generated/l10n.dart';
import 'package:tokenlab_challenge/presentation/common/async_snapshot_response_view.dart';
import 'package:tokenlab_challenge/presentation/common/indicators/indicators.dart';

import 'package:domain/model/model.dart';

import 'movie_details_bloc.dart';
import 'movie_details_screen_state.dart';

class MovieDetailsScreen extends StatelessWidget {
  MovieDetailsScreen({@required this.movieId, @required this.bloc})
      : assert(movieId != null),
        assert(bloc != null);

  final int movieId;
  final MovieDetailsBloc bloc;

  final _focusDetectorKey = UniqueKey();

  static Widget create(int id) => ProxyProvider3<GetMovieDetailsUC,
          FavoriteMovieUC, UnfavoriteMovieUC, MovieDetailsBloc>(
        update: (context, getMovieDetails, favoriteMovie, unfavoriteMovie,
                movieDetailsBloc) =>
            movieDetailsBloc ??
            MovieDetailsBloc(
                getMovieDetails: getMovieDetails,
                favoriteMovie: favoriteMovie,
                unfavoriteMovie: unfavoriteMovie,
                movieId: id),
        dispose: (context, bloc) => bloc.dispose(),
        child: Consumer<MovieDetailsBloc>(
          builder: (context, bloc, child) => MovieDetailsScreen(
            movieId: id,
            bloc: bloc,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => FocusDetector(
        key: _focusDetectorKey,
        onFocusGained: () => bloc.onFocusGain.add(null),
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).detailsScreenTopTitle),
            centerTitle: true,
          ),
          body: StreamBuilder<MovieDetailsBodyState>(
            stream: bloc.onNewState,
            builder: (context, snapshot) =>
                AsyncSnapshotResponseView<Loading, Error, Success>(
              snapshot: snapshot,
              successWidgetBuilder: (context, snapshot) => _MovieDetailsTile(
                onFavoriteTap: () => bloc.onFavoriteTap.add(null),
                movieDetails: snapshot.movieDetails,
              ),
              errorWidgetBuilder: (context, snapshot) => ErrorIndicator(
                type: snapshot.type,
                onTryAgainTap: () => bloc.onTryAgain.add(null),
              ),
              loadingWidgetBuilder: (context, snapshot) => LoadingIndicator(),
            ),
          ),
        ),
      );
}

class _MovieDetailsTile extends StatelessWidget {
  const _MovieDetailsTile({
    @required this.movieDetails,
    @required this.onFavoriteTap,
  })  : assert(movieDetails != null),
        assert(onFavoriteTap != null);

  final VoidCallback onFavoriteTap;
  final MovieLongDetails movieDetails;

  @override
  Widget build(BuildContext context) => ListView(
        children: [
          FavoriteIndicator(
              onFavoriteTap: onFavoriteTap,
              isFavorite: movieDetails.isFavorite),
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
