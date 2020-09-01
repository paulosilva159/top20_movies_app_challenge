import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../routes/routes.dart';

PageRoute<T> _buildAdaptivePageRoute<T>({
  @required WidgetBuilder builder,
  bool fullscreenDialog = false,
  Object arguments,
}) =>
    Platform.isAndroid
        ? MaterialPageRoute(
            settings: RouteSettings(arguments: arguments),
            builder: builder,
            fullscreenDialog: fullscreenDialog,
          )
        : CupertinoPageRoute(
            settings: RouteSettings(arguments: arguments),
            builder: builder,
            fullscreenDialog: fullscreenDialog,
          );

void pushPage(BuildContext context, bool isHorizontalNavigation,
    {Object arguments}) {
  Navigator.of(context, rootNavigator: !isHorizontalNavigation).pushNamed(
    Routes.movieById(arguments),
  );
}
