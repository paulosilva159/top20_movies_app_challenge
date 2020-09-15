import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tokenlab_challenge/data/movies_repository.dart';

import 'package:tokenlab_challenge/ui/view/movies_list_screen/movies_list_screen_state.dart';

class MoviesListBloc {
  MoviesListBloc({@required this.repository}) : assert(repository != null) {
    _subscriptions
      ..add(
        Rx.merge([
          _onFocusGainController.stream,
          _onTryAgainController.stream,
        ]).flatMap((_) => _fetchMoviesList()).listen(
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

  final _onFavoriteTapController = StreamController<int>();
  Sink<int> get onFavoriteTap => _onFavoriteTapController.sink;

  final _onNewStateSubject = BehaviorSubject<MoviesListBodyState>();
  Stream<MoviesListBodyState> get onNewState => _onNewStateSubject.stream;

  Stream<MoviesListBodyState> _fetchMoviesList() async* {
    yield Loading();

    try {
      yield Success(
        moviesList: await repository.getMoviesList(),
        favoritesList: await repository.getFavoritesId(),
      );
    } catch (error) {
      yield Error(
        error: error,
      );
    }
  }

  Stream<MoviesListBodyState> _editFavorites(int movieId) async* {
    final stateData = _onNewStateSubject.value;

    if (stateData is Success) {
      if (stateData.favoritesList.contains(movieId)) {
        repository.removeFavoriteMovieId(movieId);
      } else {
        stateData.moviesList.forEach(
          (movie) {
            if (movie.id == movieId) {
              repository.upsertFavoriteMovieId(movie.id, movie.title);
            }
          },
        );
      }

      yield Success(
        moviesList: await repository.getMoviesList(),
        favoritesList: await repository.getFavoritesId(),
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
