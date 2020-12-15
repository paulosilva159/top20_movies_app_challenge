import 'dart:async';

import 'package:domain/data_observables.dart';
import 'package:domain/model/model.dart';
import 'package:domain/use_case/favorite_movie_uc.dart';
import 'package:domain/use_case/get_movie_details_uc.dart';
import 'package:domain/use_case/unfavorite_movie_uc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tokenlab_challenge/common/subscription_holder.dart';
import 'package:tokenlab_challenge/presentation/common/generic_error.dart';

import 'movie_details_screen_models.dart';

class MovieDetailsBloc with SubscriptionHolder {
  MovieDetailsBloc(
      {@required this.getMovieDetails,
      @required this.favoriteMovie,
      @required this.unfavoriteMovie,
      @required this.movieId,
      @required this.activeFavoriteUpdateStreamWrapper})
      : assert(getMovieDetails != null),
        assert(favoriteMovie != null),
        assert(unfavoriteMovie != null),
        assert(movieId != null),
        assert(activeFavoriteUpdateStreamWrapper != null) {
    Rx.merge([
      Stream.value(null),
      _onTryAgainController.stream,
      activeFavoriteUpdateStreamWrapper.value,
    ])
        .flatMap(
          (_) => _fetchMovieLongDetails(),
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptions);

    _onFavoriteTapController.stream
        .flatMap(
          (_) => _toogleFavoriteState(_onNewActionController),
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptions);
  }

  final int movieId;

  final GetMovieDetailsUC getMovieDetails;
  final FavoriteMovieUC favoriteMovie;
  final UnfavoriteMovieUC unfavoriteMovie;
  final ActiveFavoriteUpdateStreamWrapper activeFavoriteUpdateStreamWrapper;

  final _onTryAgainController = StreamController<void>();
  Sink<void> get onTryAgain => _onTryAgainController.sink;

  final _onFavoriteTapController = StreamController<void>();
  Sink<void> get onFavoriteTap => _onFavoriteTapController.sink;

  final _onNewActionController = PublishSubject<MovieDetailsBodyAction>();
  Stream<MovieDetailsBodyAction> get onNewAction =>
      _onNewActionController.stream;

  final _onNewStateSubject = BehaviorSubject<MovieDetailsBodyState>();
  Stream<MovieDetailsBodyState> get onNewState => _onNewStateSubject.stream;

  Stream<MovieDetailsBodyState> _fetchMovieLongDetails() async* {
    yield Loading();

    try {
      yield await getMovieDetails
          .getFuture(
            params: GetMovieDetailsUCParams(movieId),
          )
          .then(
            (movie) => Success(
              movieDetails: movie,
            ),
          );
    } catch (error) {
      yield Error(
        type: mapToGenericErrorType(error),
      );
    }
  }

  Stream<MovieDetailsBodyState> _toogleFavoriteState(Sink eventSink) async* {
    final stateData = _onNewStateSubject.value;

    if (stateData is Success) {
      final movie = stateData.movieDetails;

      try {
        if (movie.isFavorite) {
          await unfavoriteMovie.getFuture(
            params: UnfavoriteMovieUCParams(movieId),
          );

          eventSink.add(
            ShowFavoriteTogglingSuccess(
                title: movie.title, isToFavorite: false),
          );
        } else {
          await favoriteMovie.getFuture(
            params: FavoriteMovieUCParams(movieId),
          );

          eventSink.add(
            ShowFavoriteTogglingSuccess(title: movie.title, isToFavorite: true),
          );
        }

        yield Success(
          movieDetails: MovieLongDetails(
            isFavorite: !movie.isFavorite,
            voteCount: movie.voteCount,
            id: movie.id,
            voteAverage: movie.voteAverage,
            tagline: movie.tagline,
            overview: movie.overview,
            title: movie.title,
          ),
        );
      } catch (error) {
        eventSink.add(
          ShowFavoriteTogglingError(),
        );
      }
    }
  }

  void dispose() {
    _onFavoriteTapController.close();
    _onNewActionController.close();
    _onTryAgainController.close();
    _onNewStateSubject.close();
    disposeAll();
  }
}
