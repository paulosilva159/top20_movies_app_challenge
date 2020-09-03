import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

import 'package:tokenlab_challenge/data/dio/dio_client.dart';

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
        _onTryAgainSubject.stream
            .flatMap((value) => _fetchMovieLongDetails())
            .listen(
              (_onNewStateSubject.add),
            ),
      );
  }

  final int movieId;

  final _subscriptions = CompositeSubscription();

  final _onTryAgainSubject = StreamController<void>();
  Sink<void> get onTryAgain => _onTryAgainSubject.sink;

  final _onNewStateSubject = BehaviorSubject<MovieDetailsBodyState>();
  Stream<MovieDetailsBodyState> get onNewState => _onNewStateSubject;

  Stream<MovieDetailsBodyState> _fetchMovieLongDetails() async* {
    yield Loading();

    try {
      yield Success(
        movieDetails: await DioClient().getMovieDetails(movieId),
      );
    } catch (error) {
      yield Error(
        error: error.error,
      );
    }
  }

  void dispose() {
    _onTryAgainSubject.close();
    _onNewStateSubject.close();
    _subscriptions.dispose();
  }
}
