import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

import 'package:tokenlab_challenge/data/movies_repository.dart';

import 'package:tokenlab_challenge/ui/view/movie_details_screen/movie_details_screen_state.dart';

class MovieDetailsBloc {
  MovieDetailsBloc({
    @required this.movieId,
  }) : assert(movieId != null) {
    _subscriptions
      ..add(
        _fetchMovieLongDetails().listen(
          (_onNewStateSubject.add),
        ),
      )
      ..add(
        _onTryAgainController.stream
            .flatMap((_) => _fetchMovieLongDetails())
            .listen(
              (_onNewStateSubject.add),
            ),
      );
  }

  final int movieId;

  final _repository = MoviesRepository();

  final _subscriptions = CompositeSubscription();

  final _onTryAgainController = StreamController<void>();
  Sink<void> get onTryAgain => _onTryAgainController.sink;

  final _onNewStateSubject = BehaviorSubject<MovieDetailsBodyState>();
  Stream<MovieDetailsBodyState> get onNewState => _onNewStateSubject.stream;

  Stream<MovieDetailsBodyState> _fetchMovieLongDetails() async* {
    yield Loading();

    try {
      yield Success(
          movieDetails: await _repository.getMovieDetails(movieId),
          isFavorite: await _repository
              .getFavoritesId()
              .then((favoritesList) => favoritesList.contains(movieId)));
    } catch (error) {
      yield Error(
        error: error,
      );
    }
  }

  void dispose() {
    _onTryAgainController.close();
    _onNewStateSubject.close();
    _subscriptions.dispose();
  }
}
