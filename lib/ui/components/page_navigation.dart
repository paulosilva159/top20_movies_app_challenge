import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../ui/view/movie_details_screen/movie_details_screen.dart';

PageRoute<T> _buildAdaptivePageRoute<T>({
  @required WidgetBuilder builder,
  bool fullscreenDialog = false,
  Object parameter,
}) =>
    Platform.isAndroid
        ? MaterialPageRoute(
            settings: RouteSettings(arguments: parameter),
            builder: builder,
            fullscreenDialog: fullscreenDialog,
          )
        : CupertinoPageRoute(
            settings: RouteSettings(arguments: parameter),
            builder: builder,
            fullscreenDialog: fullscreenDialog,
          );

void pushPage(BuildContext context, bool isHorizontalNavigation,
    {Object parameter}) {
  Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
    _buildAdaptivePageRoute(
      builder: (context) => MovieDetailsScreen(),
      fullscreenDialog: !isHorizontalNavigation,
      parameter: parameter,
    ),
  );
}
