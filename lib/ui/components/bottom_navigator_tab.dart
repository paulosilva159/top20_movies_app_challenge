import 'package:flutter/widgets.dart';

class BottomNavigationTab {
  BottomNavigationTab({
    @required this.bottomNavigationBarItem,
    @required this.navigatorKey,
    @required this.initialRouteName,
  })  : assert(bottomNavigationBarItem != null),
        assert(navigatorKey != null),
        assert(initialRouteName != null);

  final BottomNavigationBarItem bottomNavigationBarItem;
  final GlobalKey<NavigatorState> navigatorKey;
  final String initialRouteName;
}
