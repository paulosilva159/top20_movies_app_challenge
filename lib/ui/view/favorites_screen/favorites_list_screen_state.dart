import 'package:meta/meta.dart';

abstract class FavoritesListScreenState {}

class Success implements FavoritesListScreenState {
  Success({@required this.favoritesId}) : assert(favoritesId != null);

  final List<int> favoritesId;
}

class Loading implements FavoritesListScreenState {}

class Error implements FavoritesListScreenState {
  Error({@required this.error}) : assert(error != null);

  final dynamic error;
}
