import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tokenlab_challenge/data/movies_repository.dart';
import 'package:tokenlab_challenge/ui/view/favorites_screen/favorites_list_screen_state.dart';

import 'package:tokenlab_challenge/data/model/model.dart';

class FavoritesListBloc {
  FavoritesListBloc({@required this.repository}) : assert(repository != null) {
    _subscriptions
      ..add(
        _fetchMoviesList().listen(
          (_onNewStateSubject.add),
        ),
      )
      ..add(
        Rx.merge([
          _onTryAgainController.stream,
          _onFocusGainController.stream,
        ]).flatMap((_) => _fetchMoviesList()).listen(
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

    List<MovieShortDetailsCM> favoritesList;

    await Future.wait([repository.getFavorites(), repository.getMoviesList()])
        .then(
      (futureList) {
        final favoritesId = List<int>.from(futureList[0]);

        favoritesList = List<MovieShortDetailsCM>.from(futureList[1])
            .where((movie) => favoritesId.contains(movie.id))
            .toList();
      },
    );

    try {
      yield Success(
        favorites: favoritesList,
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
