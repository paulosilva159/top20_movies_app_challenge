import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

import 'package:tokenlab_challenge/data/movies_repository.dart';

class FavoriteItemBloc {
  FavoriteItemBloc({@required this.repository, @required this.movieId})
      : assert(movieId != null),
        assert(repository != null) {
    _subscriptions
      ..add(_fetchFavorite().listen(_onNewStateSubject.add))
      ..add(_onFavoriteTapController.stream
          .flatMap<bool>(_editFavorites)
          .listen(_onNewStateSubject.add));
  }

  final int movieId;

  final MoviesRepository repository;

  final _subscriptions = CompositeSubscription();

  final _onFavoriteTapController = StreamController<String>();
  Sink<String> get onFavoriteTap => _onFavoriteTapController.sink;

  final _onNewStateSubject = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get onNewState => _onNewStateSubject.stream;

  Stream<bool> _fetchFavorite() async* {
    bool isFavorite;

    await repository
        .getFavoritesId()
        .then((value) => isFavorite = value.contains(movieId))
        .catchError(print);

    yield isFavorite;
  }

  Stream<bool> _editFavorites(String movieName) async* {
    bool isFavorite;

    await repository.getFavoritesId().then((value) {
      isFavorite = value.contains(movieId);

      if (!isFavorite) {
        repository.upsertFavoriteMovieId(movieId, movieName);
      } else {
        repository.removeFavoriteMovieId(movieId);
      }
    }).catchError(print);

    yield !isFavorite;
  }

  void dispose() {
    _onFavoriteTapController.close();
    _onNewStateSubject.close();
    _subscriptions.dispose();
  }
}
