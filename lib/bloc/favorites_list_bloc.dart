import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tokenlab_challenge/data/movies_repository.dart';
import 'package:tokenlab_challenge/ui/view/favorites_screen/favorites_list_screen_state.dart';

class FavoritesListBloc {
  FavoritesListBloc({@required this.repository}) : assert(repository != null) {
    _subscriptions
      ..add(
        _fetchMoviesList().listen(
          (_onNewStateSubject.add),
        ),
      )
      ..add(
        Rx.merge(
          [
            _onTryAgainController.stream,
            _onFocusGainController.stream,
          ],
        )
            .flatMap(
              (_) => _fetchMoviesList(),
            )
            .listen(
              (_onNewStateSubject.add),
            ),
      );
  }

  final MoviesRepository repository;

  final _subscriptions = CompositeSubscription();

  final _onTryAgainController = StreamController<void>();
  Sink<void> get onTryAgain => _onTryAgainController.sink;

  final _onFocusGainController = StreamController<void>();
  Sink<void> get onFocusGain => _onFocusGainController.sink;

  final _onNewStateSubject = BehaviorSubject<FavoritesListScreenState>();
  Stream<FavoritesListScreenState> get onNewState => _onNewStateSubject.stream;

  Stream<FavoritesListScreenState> _fetchMoviesList() async* {
    yield Loading();

    try {
      yield Success(
        favorites: await repository.getFavorites(),
      );
    } catch (error) {
      yield Error(
        error: error,
      );
    }
  }

  void dispose() {
    _onFocusGainController.close();
    _onTryAgainController.close();
    _onNewStateSubject.close();
    _subscriptions.dispose();
  }
}
