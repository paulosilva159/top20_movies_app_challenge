import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../ui/view/movie_details_screen/movie_details_screen.dart';

PageRoute<T> _buildAdaptivePageRoute<T>({
  @required WidgetBuilder builder,
  bool fullscreenDialog = false,
  int movieId,
}) =>
    Platform.isAndroid
        ? MaterialPageRoute(
            settings: RouteSettings(arguments: movieId),
            builder: builder,
            fullscreenDialog: fullscreenDialog,
          )
        : CupertinoPageRoute(
            settings: RouteSettings(arguments: movieId),
            builder: builder,
            fullscreenDialog: fullscreenDialog,
          );

void pushPage(BuildContext context, bool isHorizontalNavigation,
    {int movieId}) {
  Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
    _buildAdaptivePageRoute(
      builder: (context) => MovieDetailsScreen(),
      fullscreenDialog: !isHorizontalNavigation,
      movieId: movieId,
    ),
  );
}
