import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:tokenlab_challenge/data/movies_repository.dart';
import 'package:tokenlab_challenge/data/model/cache/movie_short_details_cm.dart';

import 'package:tokenlab_challenge/ui/view/movies_list_screen/movies_list_screen_state.dart';

class MoviesListBloc {
  MoviesListBloc() {
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

  final _repository = MoviesRepository();
  final _subscriptions = CompositeSubscription();

  final _onFocusGainController = StreamController<void>();
  Sink<void> get onFocusGain => _onFocusGainController.sink;

  final _onTryAgainController = StreamController<void>();
  Sink<void> get onTryAgain => _onTryAgainController.sink;

  final _onFavoriteTapController = StreamController<MovieShortDetailsCM>();
  Sink<MovieShortDetailsCM> get onFavoriteTap => _onFavoriteTapController.sink;

  final _onNewStateSubject = BehaviorSubject<MoviesListBodyState>();
  Stream<MoviesListBodyState> get onNewState => _onNewStateSubject.stream;

  Stream<MoviesListBodyState> _fetchMoviesList() async* {
    yield Loading();

    try {
      yield Success(
        moviesList: await _repository.getMoviesList(),
        favoritesList: await _repository.getFavorites(),
      );
    } catch (error) {
      yield Error(
        error: error,
      );
    }
  }

  Stream<MoviesListBodyState> _editFavorites(
      MovieShortDetailsCM movieDetails) async* {
    final stateData = _onNewStateSubject.value;

    if (stateData is Success) {
      if (stateData.favoritesList.contains(movieDetails)) {
        await _repository.removeFavoriteMovieId(movieDetails.id);
      } else {
        await _repository.upsertFavoriteMovieId(movieDetails.id);
      }

      yield Success(
        moviesList: await _repository.getMoviesList(),
        favoritesList: await _repository.getFavorites(),
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
