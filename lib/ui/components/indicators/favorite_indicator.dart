import 'package:flutter/material.dart';

import 'package:tokenlab_challenge/bloc/favorite_item_bloc.dart';
import 'package:tokenlab_challenge/ui/components/indicators/indicators.dart';

class FavoriteIndicator extends StatefulWidget {
  const FavoriteIndicator(
      {@required this.movieId, @required this.movieName, Key key})
      : assert(movieId != null),
        assert(movieName != null),
        super(key: key);

  final int movieId;
  final String movieName;

  @override
  _FavoriteIndicatorState createState() => _FavoriteIndicatorState();
}

class _FavoriteIndicatorState extends State<FavoriteIndicator> {
  FavoriteItemBloc _bloc;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bloc =
        FavoriteItemBloc(movieId: widget.movieId, movieName: widget.movieName);

    super.initState();
  }

  dynamic _booleanCheck(bool state,
      {@required var nullState, var trueState, var falseState}) {
    if (state == null) {
      return nullState;
    } else if (falseState == null || trueState == null) {
      return falseState ?? trueState;
      // TODO(paulovictor): checar uma melhor forma de fazer essa checagem
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
              trueState: () => _bloc.onFavoriteTap.add(null),
            ));
      });
}
