import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

import 'package:tokenlab_challenge/data/repository/movies_repository.dart';
import 'package:tokenlab_challenge/presentation/common/generic_error.dart';

import 'movie_details_screen_state.dart';

class MovieDetailsBloc {
  MovieDetailsBloc({
    @required this.repository,
    @required this.movieId,
  }) : assert(movieId != null) {
    _subscriptions
      ..add(
        Rx.merge(
          [
            _onTryAgainController.stream,
            _onFocusGainController.stream,
          ],
        )
            .flatMap(
              (_) => _fetchMovieLongDetails(),
            )
            .listen(_onNewStateSubject.add),
      )
      ..add(
        _onFavoriteTapController.stream
            .flatMap(
              (_) => _editFavorites(),
            )
            .listen(_onNewStateSubject.add),
      );
  }

  final int movieId;

  final MoviesRepository repository;

  final _subscriptions = CompositeSubscription();

  final _onTryAgainController = StreamController<void>();
  Sink<void> get onTryAgain => _onTryAgainController.sink;

  final _onFocusGainController = StreamController<void>();
  Sink<void> get onFocusGain => _onFocusGainController.sink;

  final _onFavoriteTapController = StreamController<void>();
  Sink<void> get onFavoriteTap => _onFavoriteTapController.sink;

  final _onNewStateSubject = BehaviorSubject<MovieDetailsBodyState>();
  Stream<MovieDetailsBodyState> get onNewState => _onNewStateSubject.stream;

  Stream<MovieDetailsBodyState> _fetchMovieLongDetails() async* {
    yield Loading();

    try {
      yield await repository.getMovieDetails(movieId).then(
            (movie) => Success(
              movieDetails: movie,
            ),
          );
    } catch (error) {
      yield Error(type: mapToGenericErrorType(error));
    }
  }

  Stream<MovieDetailsBodyState> _editFavorites() async* {
    final stateData = _onNewStateSubject.value;

    if (stateData is Success) {
      if (stateData.movieDetails.isFavorite) {
        await repository.unfavoriteMovie(movieId);
      } else {
        await repository.favoriteMovie(movieId);
      }

      yield await repository.getMovieDetails(movieId).then(
            (movie) => Success(
              movieDetails: movie,
            ),
          );
    }
  }

  void dispose() {
    _onFavoriteTapController.close();
    _onFocusGainController.close();
    _onTryAgainController.close();
    _onNewStateSubject.close();
    _subscriptions.dispose();
  }
}
