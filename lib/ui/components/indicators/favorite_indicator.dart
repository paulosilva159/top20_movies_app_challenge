import 'package:flutter/material.dart';

import 'package:tokenlab_challenge/ui/components/indicators/indicators.dart';

class FavoriteIndicator extends StatelessWidget {
  const FavoriteIndicator({@required this.onFavoriteTap, this.isFavorite})
      : assert(onFavoriteTap != null);

  final VoidCallback onFavoriteTap;
  final bool isFavorite;

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
  Widget build(BuildContext context) => IconButton(
      icon: _booleanCheck(
        isFavorite,
        nullState: LoadingIndicator(),
        trueState: const Icon(Icons.favorite, color: Colors.pinkAccent),
        falseState: const Icon(Icons.favorite_border),
      ),
      onPressed: _booleanCheck(
        isFavorite,
        nullState: null,
        trueState: onFavoriteTap,
      ));
}
