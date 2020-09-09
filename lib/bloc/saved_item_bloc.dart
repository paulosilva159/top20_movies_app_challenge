import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';
import 'package:tokenlab_challenge/data/repository.dart';

class SavedItemBloc {
  SavedItemBloc({
    @required this.movieId,
  }) : assert(movieId != null) {
    _subscriptions.add(
      _fetchFavorite().listen(_onNewStateSubject.add),
    );
  }

  final _repository = Repository();

  final int movieId;

  final _subscriptions = CompositeSubscription();

  final _onNewStateSubject = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get onNewState => _onNewStateSubject.stream;

  Stream<bool> _fetchFavorite() async* {
    bool isFavorite;

    try {
      await _repository
          .getFavorite()
          .then((value) => isFavorite = value.contains(movieId));
    } catch (error) {
      print(error);
    }

    yield isFavorite;
  }

  void get onSaveMovieIdTap => _repository.saveFavoriteMovieId(movieId);

  void dispose() {
    _onNewStateSubject.close();
    _subscriptions.dispose();
  }
}
