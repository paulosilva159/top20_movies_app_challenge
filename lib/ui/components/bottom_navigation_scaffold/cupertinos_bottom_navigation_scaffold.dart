import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:fluro/fluro.dart';

import 'package:tokenlab_challenge/ui/components/bottom_navigator_tab.dart';

class CupertinoBottomNavigationScaffold extends StatelessWidget {
  const CupertinoBottomNavigationScaffold({
    @required this.navigationBarItems,
    @required this.onItemSelected,
    @required this.selectedIndex,
    Key key,
  })  : assert(navigationBarItems != null),
        assert(onItemSelected != null),
        assert(selectedIndex != null),
        super(key: key);

  final List<BottomNavigationTab> navigationBarItems;
  final ValueChanged<int> onItemSelected;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) => CupertinoTabScaffold(
        controller: CupertinoTabController(initialIndex: selectedIndex),
        tabBar: CupertinoTabBar(
          items: navigationBarItems
              .map((item) => item.bottomNavigationBarItem)
              .toList(),
          onTap: onItemSelected,
        ),
        tabBuilder: (context, index) {
          final barItem = navigationBarItems[index];

          return CupertinoTabView(
              navigatorKey: barItem.navigatorKey,
              onGenerateRoute: (settings) {
                var routeSettings = settings;

                if (settings.name == '/') {
                  routeSettings =
                      settings.copyWith(name: barItem.initialRouteName);
                }

                return Router.appRouter
                    .matchRoute(context, routeSettings.name,
                        routeSettings: routeSettings)
                    .route;
              });
        },
      );
}
