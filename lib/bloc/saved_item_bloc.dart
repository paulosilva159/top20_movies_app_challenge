import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';
import 'package:tokenlab_challenge/data/repository.dart';

class SavedItemBloc {
  SavedItemBloc({
    @required this.movieId,
  }) : assert(movieId != null) {
    _subscriptions
      ..add(_fetchFavorite().listen(_onNewStateSubject.add))
      ..add(_onFavoriteTapped.stream
          .flatMap<bool>((_) => _toogleFavorite())
          .listen(_onNewStateSubject.add));
  }
  final int movieId;

  final _repository = Repository();

  final _subscriptions = CompositeSubscription();

  final _onFavoriteTapped = StreamController<void>();
  Sink<void> get onFavoriteTapped => _onFavoriteTapped.sink;

  final _onNewStateSubject = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get onNewState => _onNewStateSubject.stream;

  Stream<bool> _fetchFavorite() async* {
    bool isFavorite;

    try {
      await _repository
          .getFavorites()
          .then((value) => isFavorite = value.contains(movieId));
    } catch (error) {
      print(error);
    }

    yield isFavorite;
  }

  Stream<bool> _toogleFavorite() async* {
    bool isFavorite;

    try {
      await _repository
          .getFavorites()
          .then((value) => isFavorite = value.contains(movieId));

      if (!isFavorite) {
        _repository.saveFavoriteMovieId(movieId);
      } else {
        _repository.removeFavoriteMovieId(movieId);
      }
    } catch (error) {
      print(error);
    }

    yield !isFavorite;
  }

  void get onSaveMovieIdTap => _repository.saveFavoriteMovieId(movieId);

  void dispose() {
    _onFavoriteTapped.close();
    _onNewStateSubject.close();
    _subscriptions.dispose();
  }
}
