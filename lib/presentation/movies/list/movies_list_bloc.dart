import 'dart:async';

import 'package:domain/data_observables.dart';
import 'package:domain/model/model.dart';
import 'package:domain/use_case/favorite_movie_uc.dart';
import 'package:domain/use_case/get_movies_list_uc.dart';
import 'package:domain/use_case/unfavorite_movie_uc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tokenlab_challenge/common/subscription_holder.dart';
import 'package:tokenlab_challenge/presentation/common/generic_error.dart';

import 'movies_list_screen_models.dart';

class MoviesListBloc with SubscriptionHolder {
  MoviesListBloc({
    @required this.getMoviesList,
    @required this.favoriteMovie,
    @required this.unfavoriteMovie,
    @required this.activeFavoriteUpdateStreamWrapper,
  })  : assert(getMoviesList != null),
        assert(favoriteMovie != null),
        assert(unfavoriteMovie != null),
        assert(activeFavoriteUpdateStreamWrapper != null) {
    Rx.merge([
      Stream.value(null),
      activeFavoriteUpdateStreamWrapper.value,
      _onTryAgainController.stream,
    ])
        .flatMap(
          (_) => _fetchMoviesList(),
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptions);

    _onFavoriteTapController.stream
        .flatMap(
          (movie) => _toogleFavoriteState(movie, _onNewActionController),
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptions);
  }

  final GetMoviesListUC getMoviesList;
  final FavoriteMovieUC favoriteMovie;
  final UnfavoriteMovieUC unfavoriteMovie;
  final ActiveFavoriteUpdateStreamWrapper activeFavoriteUpdateStreamWrapper;

  final _onTryAgainController = StreamController<void>();
  Sink<void> get onTryAgain => _onTryAgainController.sink;

  final _onFavoriteTapController = StreamController<MovieShortDetails>();
  Sink<MovieShortDetails> get onFavoriteTap => _onFavoriteTapController.sink;

  final _onNewActionController = PublishSubject<MoviesListBodyAction>();
  Stream<MoviesListBodyAction> get onNewAction => _onNewActionController.stream;

  final _onNewStateSubject = BehaviorSubject<MoviesListBodyState>();
  Stream<MoviesListBodyState> get onNewState => _onNewStateSubject.stream;

  Stream<MoviesListBodyState> _fetchMoviesList() async* {
    yield Loading();

    try {
      yield await getMoviesList.getFuture().then(
            (moviesList) => Success(
              moviesList: moviesList,
            ),
          );
    } catch (error) {
      yield Error(
        type: mapToGenericErrorType(error),
      );
    }
  }

  Stream<MoviesListBodyState> _toogleFavoriteState(
      MovieShortDetails movieDetails, Sink eventSink) async* {
    final stateData = _onNewStateSubject.value;

    if (stateData is Success) {
      final moviesList = stateData.moviesList;

      try {
        if (moviesList
            .where((movie) => movie.isFavorite)
            .contains(movieDetails)) {
          await unfavoriteMovie.getFuture(
            params: UnfavoriteMovieUCParams(movieDetails.id),
          );

          eventSink.add(
            ShowFavoriteTogglingSuccess(
                title: movieDetails.title, isToFavorite: false),
          );
        } else {
          await favoriteMovie.getFuture(
            params: FavoriteMovieUCParams(movieDetails.id),
          );

          eventSink.add(
            ShowFavoriteTogglingSuccess(
                title: movieDetails.title, isToFavorite: true),
          );
        }

        yield Success(
          moviesList: moviesList
              .map((movie) => movie == movieDetails
                  ? MovieShortDetails(
                      isFavorite: !movie.isFavorite,
                      id: movie.id,
                      title: movie.title,
                      posterUrl: movie.posterUrl,
                    )
                  : movie)
              .toList(),
        );
      } catch (error) {
        eventSink.add(ShowFavoriteTogglingError());
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
