import 'package:flutter/widgets.dart';

import 'movies_structure_type.dart';

class AppFlow {
  const AppFlow({
    @required this.title,
    @required this.movieStructureType,
    @required this.mainColor,
    @required this.iconData,
    @required this.navigatorKey,
  })  : assert(title != null),
        assert(movieStructureType != null),
        assert(mainColor != null),
        assert(iconData != null),
        assert(navigatorKey != null);

  final MovieStructureType movieStructureType;
  final String title;
  final Color mainColor;
  final IconData iconData;
  final GlobalKey<NavigatorState> navigatorKey;
}
