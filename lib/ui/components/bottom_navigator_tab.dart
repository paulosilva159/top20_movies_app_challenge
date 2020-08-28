import 'package:flutter/widgets.dart';

class BottomNavigationTab {
  BottomNavigationTab({
    @required this.bottomNavigationBarItem,
    @required this.navigatorKey,
    @required this.initialPageBuilder,
  })  : assert(bottomNavigationBarItem != null),
        assert(navigatorKey != null),
        assert(initialPageBuilder != null);

  final BottomNavigationBarItem bottomNavigationBarItem;
  final GlobalKey<NavigatorState> navigatorKey;
  final WidgetBuilder initialPageBuilder;
}
