import 'package:flutter/material.dart';
import 'package:tokenlab_challenge/bloc/saved_item_bloc.dart';
import 'package:tokenlab_challenge/ui/components/indicators/indicators.dart';

class FavoriteIndicator extends StatefulWidget {
  const FavoriteIndicator({@required this.movieId}) : assert(movieId != null);

  final int movieId;

  @override
  _FavoriteIndicatorState createState() => _FavoriteIndicatorState();
}

class _FavoriteIndicatorState extends State<FavoriteIndicator> {
  SavedItemBloc _bloc;

  @override
  void initState() {
    _bloc = SavedItemBloc(movieId: widget.movieId);

    super.initState();
  }

  dynamic _booleanCheck(bool state,
      {var nullState, var trueState, var falseState}) {
    if (state == null) {
      return nullState;
    } else if (state == true) {
      return trueState;
    } else {
      return falseState;
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: _bloc.onNewState,
      builder: (context, snapshot) {
        final bool isFavoriteState = snapshot.data;

        return IconButton(
            icon: _booleanCheck(
              isFavoriteState,
              nullState: LoadingIndicator(),
              trueState: const Icon(Icons.favorite, color: Colors.pinkAccent),
              falseState: const Icon(Icons.favorite_border),
            ),
            onPressed: _booleanCheck(
              isFavoriteState,
              nullState: null,
              trueState: () => _bloc.onFavoriteTapped.add(null),
              falseState: () => _bloc.onFavoriteTapped.add(null),
            ));
      });
}
