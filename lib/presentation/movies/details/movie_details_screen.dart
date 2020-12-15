import 'package:domain/data_observables.dart';
import 'package:domain/model/model.dart';
import 'package:domain/use_case/favorite_movie_uc.dart';
import 'package:domain/use_case/get_movie_details_uc.dart';
import 'package:domain/use_case/unfavorite_movie_uc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokenlab_challenge/generated/l10n.dart';
import 'package:tokenlab_challenge/presentation/common/action_stream_listener.dart';
import 'package:tokenlab_challenge/presentation/common/alert_dialogs/states_alert_dialog.dart';
import 'package:tokenlab_challenge/presentation/common/async_snapshot_response_view.dart';
import 'package:tokenlab_challenge/presentation/common/indicators/indicators.dart';

import 'movie_details_bloc.dart';
import 'movie_details_screen_models.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({@required this.movieId, @required this.bloc})
      : assert(movieId != null),
        assert(bloc != null);

  final int movieId;
  final MovieDetailsBloc bloc;

  static Widget create(int id) => ProxyProvider4<
          GetMovieDetailsUC,
          FavoriteMovieUC,
          UnfavoriteMovieUC,
          ActiveFavoriteUpdateStreamWrapper,
          MovieDetailsBloc>(
        update: (context, getMovieDetails, favoriteMovie, unfavoriteMovie,
                activeFavoriteUpdateStreamWrapper, movieDetailsBloc) =>
            movieDetailsBloc ??
            MovieDetailsBloc(
                getMovieDetails: getMovieDetails,
                favoriteMovie: favoriteMovie,
                unfavoriteMovie: unfavoriteMovie,
                activeFavoriteUpdateStreamWrapper:
                    activeFavoriteUpdateStreamWrapper,
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).detailsScreenTopTitle),
          centerTitle: true,
        ),
        body: ActionStreamListener<MovieDetailsBodyAction>(
          actionStream: bloc.onNewAction,
          onReceived: (event) {
            if (event is ShowFavoriteTogglingError) {
              showToogleFavoriteErrorDialog(context);
            } else if (event is ShowFavoriteTogglingSuccess) {
              showToogleFavoriteSuccessDialog(
                  context, event.title, event.isToFavorite);
            }
          },
          child: StreamBuilder<MovieDetailsBodyState>(
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
