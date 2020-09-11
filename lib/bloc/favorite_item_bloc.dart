import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

import 'package:tokenlab_challenge/data/movies_repository.dart';

class FavoriteItemBloc {
  FavoriteItemBloc({@required this.movieId, @required this.movieName})
      : assert(movieId != null),
        assert(movieName != null) {
    _subscriptions
      ..add(_fetchFavorite().listen(_onNewStateSubject.add))
      ..add(_onFavoriteTapController.stream
          .flatMap<bool>((_) => _editFavorites())
          .listen(_onNewStateSubject.add));
  }
  final int movieId;
  final String movieName;

  final _repository = MoviesRepository();

  final _subscriptions = CompositeSubscription();

  final _onFavoriteTapController = StreamController<void>();
  Sink<void> get onFavoriteTap => _onFavoriteTapController.sink;

  final _onNewStateSubject = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get onNewState => _onNewStateSubject.stream;

  Stream<bool> _fetchFavorite() async* {
    bool isFavorite;

    await _repository
        .getFavoritesId()
        .then((value) => isFavorite = value.contains(movieId))
        .catchError(print);

    yield isFavorite;
  }

  Stream<bool> _editFavorites() async* {
    bool isFavorite;

    print('oi');

    await _repository.getFavoritesId().then((value) {
      isFavorite = value.contains(movieId);

      if (!isFavorite) {
        _repository.upsertFavoriteMovieId(movieId, movieName);
      } else {
        _repository.removeFavoriteMovieId(movieId);
      }
    }).catchError(print);

    print(isFavorite);

    yield !isFavorite;
  }

  void dispose() {
    _onFavoriteTapController.close();
    _onNewStateSubject.close();
    _subscriptions.dispose();
  }
}
