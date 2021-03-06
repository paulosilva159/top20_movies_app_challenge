import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tokenlab_challenge/generated/l10n.dart';

import 'common/app_flow.dart';
import 'common/bottom_navigation_scaffold/adaptive_bottom_navigation_scaffold.dart';
import 'common/bottom_navigator_tab.dart';
import 'common/movies_structure_type.dart';

import 'common/routes.dart';

class MoviesInitialScreen extends StatefulWidget {
  @override
  _MoviesInitialScreenState createState() => _MoviesInitialScreenState();
}

class _MoviesInitialScreenState extends State<MoviesInitialScreen> {
  Locale _userLocale;
  List<AppFlow> _appFlows;

  @override
  void didChangeDependencies() {
    final newLocale = Localizations.localeOf(context);

    if (newLocale != _userLocale) {
      _userLocale = newLocale;

      _appFlows = [
        AppFlow(
          title: S.of(context).bottomNavigationItemListTitle,
          movieStructureType: MovieStructureType.list,
          iconData: Icons.list,
          mainColor: Colors.amber,
          navigatorKey: GlobalKey<NavigatorState>(),
        ),
        AppFlow(
          title: S.of(context).bottomNavigationItemGridTitle,
          movieStructureType: MovieStructureType.grid,
          iconData: Icons.grid_on,
          mainColor: Colors.pinkAccent,
          navigatorKey: GlobalKey<NavigatorState>(),
        ),
      ];
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => AdaptiveBottomNavigationScaffold(
        key: ValueKey(_userLocale),
        navigationBarItems: _appFlows
            .map(
              (flow) => BottomNavigationTab(
                bottomNavigationBarItem: BottomNavigationBarItem(
                  title: Text(flow.title),
                  icon: Icon(flow.iconData),
                ),
                navigatorKey: flow.navigatorKey,
                initialRouteName: Routes.moviesListByStructure(
                    EnumToString.convertToString(flow.movieStructureType)),
              ),
            )
            .toList(),
      );
}
