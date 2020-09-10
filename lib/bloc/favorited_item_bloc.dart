import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

import 'package:tokenlab_challenge/data/movies_repository.dart';

class SavedItemBloc {
  SavedItemBloc({@required this.movieId}) : assert(movieId != null) {
    _subscriptions
      ..add(_fetchFavorite().listen(_onNewStateSubject.add))
      ..add(_onFavoriteTapController.stream
          .flatMap<bool>((_) => _editFavorites())
          .listen(_onNewStateSubject.add));
  }
  final int movieId;

  final _repository = MoviesRepository();

  final _subscriptions = CompositeSubscription();

  final _onFavoriteTapController = StreamController<void>();
  Sink<void> get onFavoriteTap => _onFavoriteTapController.sink;

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

  Stream<bool> _editFavorites() async* {
    bool isFavorite;

    try {
      await _repository
          .getFavorites()
          .then((value) => isFavorite = value.contains(movieId));

      if (!isFavorite) {
        _repository.upsertFavoriteMovieId(movieId);
      } else {
        _repository.removeFavoriteMovieId(movieId);
      }
    } catch (error) {
      print(error);
    }

    yield !isFavorite;
  }

  void dispose() {
    _onFavoriteTapController.close();
    _onNewStateSubject.close();
    _subscriptions.dispose();
  }
}
