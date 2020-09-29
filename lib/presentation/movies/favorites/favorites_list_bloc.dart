import 'dart:async';

import 'package:domain/data_observables.dart';
import 'package:domain/use_case/get_favorites_list_uc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tokenlab_challenge/common/subscription_holder.dart';
import 'package:tokenlab_challenge/presentation/common/generic_error.dart';

import 'favorites_list_screen_state.dart';

class FavoritesListBloc with SubscriptionHolder {
  FavoritesListBloc({
    @required this.getFavoritesList,
    @required this.activeFavoriteUpdateStreamWrapper,
  })  : assert(getFavoritesList != null),
        assert(activeFavoriteUpdateStreamWrapper != null) {
    Rx.merge([
      Stream.value(null),
      activeFavoriteUpdateStreamWrapper.value,
      _onTryAgainController.stream,
    ])
        .flatMap(
          (_) => _fetchMoviesList(),
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptions);
  }

  final GetFavoritesListUC getFavoritesList;
  final ActiveFavoriteUpdateStreamWrapper activeFavoriteUpdateStreamWrapper;

  final _onTryAgainController = StreamController<void>();
  Sink<void> get onTryAgain => _onTryAgainController.sink;

  final _onNewStateSubject = BehaviorSubject<FavoritesListScreenState>();
  Stream<FavoritesListScreenState> get onNewState => _onNewStateSubject.stream;

  Stream<FavoritesListScreenState> _fetchMoviesList() async* {
    yield Loading();

    try {
      yield Success(
        favorites: await getFavoritesList.getFuture(),
      );
    } catch (error) {
      yield Error(
        type: mapToGenericErrorType(error),
      );
    }
  }

  void dispose() {
    _onTryAgainController.close();
    _onNewStateSubject.close();
    disposeAll();
  }
}
