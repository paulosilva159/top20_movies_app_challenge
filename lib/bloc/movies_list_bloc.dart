import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tokenlab_challenge/data/model/model.dart';

import 'package:tokenlab_challenge/data/movies_repository.dart';
import 'package:tokenlab_challenge/data/model/cache/movie_short_details_cm.dart';

import 'package:tokenlab_challenge/ui/view/movies_list_screen/movies_list_screen_state.dart';

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

  final _onFavoriteTapController = StreamController<MovieShortDetailsCM>();
  Sink<MovieShortDetailsCM> get onFavoriteTap => _onFavoriteTapController.sink;

  final _onNewStateSubject = BehaviorSubject<MoviesListBodyState>();
  Stream<MoviesListBodyState> get onNewState => _onNewStateSubject.stream;

  Stream<MoviesListBodyState> _fetchMoviesList() async* {
    yield Loading();

    try {
      yield await Future.wait([
        repository.getMoviesList(),
        repository.getFavorites(),
      ]).then(
        (lists) => Success(
          moviesList: lists[0],
          favoritesList: lists[1],
        ),
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
        await repository.removeFavoriteMovieId(movieDetails.id);
      } else {
        await repository.upsertFavoriteMovieId(movieDetails.id);
      }

      yield await Future.wait([
        repository.getMoviesList(),
        repository.getFavorites(),
      ]).then(
        (lists) => Success(
          moviesList: lists[0],
          favoritesList: lists[1],
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
