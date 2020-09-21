import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tokenlab_challenge/data/repository/movies_repository.dart';

import 'package:domain/model/model.dart';

import 'movies_list_screen_state.dart';

class MoviesListBloc {
  MoviesListBloc({@required this.repository}) : assert(repository != null) {
    _subscriptions
      ..add(
        Rx.merge(
          [
            _onFocusGainController.stream,
            _onTryAgainController.stream,
          ],
        )
            .flatMap(
              (_) => _fetchMoviesList(),
            )
            .listen(
              (_onNewStateSubject.add),
            ),
      )
      ..add(
        _onFavoriteTapController.stream
            .flatMap(
              _editFavorites,
            )
            .listen(_onNewStateSubject.add),
      );
  }

  final MoviesRepository repository;

  final _subscriptions = CompositeSubscription();

  final _onFocusGainController = StreamController<void>();
  Sink<void> get onFocusGain => _onFocusGainController.sink;

  final _onTryAgainController = StreamController<void>();
  Sink<void> get onTryAgain => _onTryAgainController.sink;

  final _onFavoriteTapController = StreamController<MovieShortDetails>();
  Sink<MovieShortDetails> get onFavoriteTap => _onFavoriteTapController.sink;

  final _onNewStateSubject = BehaviorSubject<MoviesListBodyState>();
  Stream<MoviesListBodyState> get onNewState => _onNewStateSubject.stream;

  Stream<MoviesListBodyState> _fetchMoviesList() async* {
    yield Loading();

    try {
      yield await repository.getMoviesList().then(
            (moviesList) => Success(
              moviesList: moviesList,
            ),
          );
    } catch (error) {
      yield Error(
        error: error,
      );
    }
  }

  Stream<MoviesListBodyState> _editFavorites(
      MovieShortDetails movieDetails) async* {
    final stateData = _onNewStateSubject.value;

    if (stateData is Success) {
      if (stateData.moviesList
          .where((movie) => movie.isFavorite)
          .contains(movieDetails)) {
        await repository.removeFavoriteMovieId(movieDetails.id);
      } else {
        await repository.upsertFavoriteMovieId(movieDetails.id);
      }

      yield await repository.getMoviesList().then(
            (moviesList) => Success(
              moviesList: moviesList,
            ),
          );
    }
  }

  void dispose() {
    _onFocusGainController.close();
    _onFavoriteTapController.close();
    _onTryAgainController.close();
    _onNewStateSubject.close();
    _subscriptions.dispose();
  }
}
