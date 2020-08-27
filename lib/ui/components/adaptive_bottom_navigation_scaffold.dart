import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:tokenlab_challenge/ui/components/bottom_navigator_tab.dart';
import 'package:tokenlab_challenge/ui/components/cupertino_bottom_navigation_tab.dart';
import 'package:tokenlab_challenge/ui/components/material_bottom_navigation_scaffold.dart';

class AdaptiveBottomNavigationScaffold extends StatefulWidget {
  const AdaptiveBottomNavigationScaffold({
    @required this.navigationBarItems,
    Key key,
  })  : assert(navigationBarItems != null),
        super(key: key);

  final List<BottomNavigationTab> navigationBarItems;

  @override
  _AdaptiveBottomNavigationScaffoldState createState() =>
      _AdaptiveBottomNavigationScaffoldState();
}

class _AdaptiveBottomNavigationScaffoldState
    extends State<AdaptiveBottomNavigationScaffold> {
  int _currentlySelectedIndex = 0;

  void onTabSelected(int newIndex) {
    if (_currentlySelectedIndex == newIndex) {
      widget.navigationBarItems[newIndex].navigatorKey.currentState
          .popUntil((route) => route.isFirst);
    }

    if (Platform.isAndroid) {
      setState(() {
        _currentlySelectedIndex = newIndex;
      });
    } else {
      _currentlySelectedIndex = newIndex;
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => !await widget
            .navigationBarItems[_currentlySelectedIndex]
            .navigatorKey
            .currentState
            .maybePop(),
        child: Platform.isAndroid
            ? _BuildMaterial(
                navigationBarItems: widget.navigationBarItems,
                onTabSelected: onTabSelected,
                currentlySelectedIndex: _currentlySelectedIndex,
              )
            : _BuildCupertino(
                navigationBarItems: widget.navigationBarItems,
                onTabSelected: onTabSelected,
                currentlySelectedIndex: _currentlySelectedIndex,
              ),
      );
}

class _BuildMaterial extends StatelessWidget {
  const _BuildMaterial({
    @required this.navigationBarItems,
    @required this.onTabSelected,
    @required this.currentlySelectedIndex,
  })  : assert(navigationBarItems != null),
        assert(onTabSelected != null),
        assert(currentlySelectedIndex != null);

  final List<BottomNavigationTab> navigationBarItems;
  final ValueChanged<int> onTabSelected;
  final int currentlySelectedIndex;

  @override
  Widget build(BuildContext context) => MaterialBottomNavigationScaffold(
        navigationBarItems: navigationBarItems,
        onItemSelected: onTabSelected,
        selectedIndex: currentlySelectedIndex,
      );
}

class _BuildCupertino extends StatelessWidget {
  const _BuildCupertino({
    @required this.navigationBarItems,
    @required this.onTabSelected,
    @required this.currentlySelectedIndex,
  })  : assert(navigationBarItems != null),
        assert(onTabSelected != null),
        assert(currentlySelectedIndex != null);

  final List<BottomNavigationTab> navigationBarItems;
  final ValueChanged<int> onTabSelected;
  final int currentlySelectedIndex;

  @override
  Widget build(BuildContext context) => CupertinoBottomNavigationScaffold(
        navigationBarItems: navigationBarItems,
        onItemSelected: onTabSelected,
        selectedIndex: currentlySelectedIndex,
      );
}
