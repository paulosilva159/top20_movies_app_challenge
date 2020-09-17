import 'package:flutter/material.dart';

class FavoriteIndicator extends StatelessWidget {
  const FavoriteIndicator({@required this.onFavoriteTap, this.isFavorite})
      : assert(onFavoriteTap != null);

  final VoidCallback onFavoriteTap;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: isFavorite
            ? const Icon(Icons.favorite, color: Colors.pinkAccent)
            : const Icon(Icons.favorite_border),
        onPressed: onFavoriteTap,
      );
}
