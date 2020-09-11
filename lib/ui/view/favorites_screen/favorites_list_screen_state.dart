import 'package:meta/meta.dart';

abstract class FavoritesListScreenState {}

class Success implements FavoritesListScreenState {
  Success({@required this.favorites}) : assert(favorites != null);

  final Map<int, String> favorites;
}

class Loading implements FavoritesListScreenState {}

class Error implements FavoritesListScreenState {
  Error({@required this.error}) : assert(error != null);

  final dynamic error;
}
