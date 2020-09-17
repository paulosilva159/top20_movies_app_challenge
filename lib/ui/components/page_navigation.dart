import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:tokenlab_challenge/routes/routes.dart';

void pushPage(BuildContext context, bool isHorizontalNavigation,
    {Object arguments}) {
  Navigator.of(context, rootNavigator: !isHorizontalNavigation).pushNamed(
    Routes.movieById(arguments),
  );
}
