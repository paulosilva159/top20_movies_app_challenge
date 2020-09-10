import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:tokenlab_challenge/data/movies_repository.dart';

import 'package:tokenlab_challenge/ui/view/movies_list_screen/movies_list_screen_state.dart';

class MoviesListBloc {
  MoviesListBloc() {
    _subscriptions
      ..add(
        _fetchMoviesList().listen(
          (_onNewStateSubject.add),
        ),
      )
      ..add(
        _onTryAgainController.stream.flatMap((_) => _fetchMoviesList()).listen(
              (_onNewStateSubject.add),
            ),
      );
  }

  final _repository = MoviesRepository();

  final _subscriptions = CompositeSubscription();

  final _onTryAgainController = StreamController<void>();
  Sink<void> get onTryAgain => _onTryAgainController.sink;

  final _onNewStateSubject = BehaviorSubject<MoviesListBodyState>();
  Stream<MoviesListBodyState> get onNewState => _onNewStateSubject.stream;

  List _moviesList;

  Stream<MoviesListBodyState> _fetchMoviesList() async* {
    yield Loading();

    try {
      _moviesList = await _repository.getMoviesList();

      yield Success(
        moviesList: _moviesList,
      );
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
