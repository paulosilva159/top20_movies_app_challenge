import 'dart:async';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../data/repository.dart';

import '../ui/view/movies_list_screen/movies_list_screen_state.dart';

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

  final _repository = Repository();

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

  bool get hasLoadMoviesListFromCache => _repository.hasLoadMoviesListFromCache;

  void get onSaveTap => _repository.saveMoviesList(_moviesList);

  void dispose() {
    _onTryAgainController.close();
    _onNewStateSubject.close();
    _subscriptions.dispose();
  }
}
