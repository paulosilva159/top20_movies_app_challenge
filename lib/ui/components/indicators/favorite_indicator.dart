import 'package:flutter/material.dart';

class FavoriteIndicator extends StatelessWidget {
  const FavoriteIndicator({@required this.isFavorite})
      : assert(isFavorite != null);

  final bool isFavorite;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.pinkAccent,
        ),
        onPressed: () {},
      );
}
