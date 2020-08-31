import 'dart:io';

import 'package:flutter/widgets.dart';

import '../bottom_navigator_tab.dart';
import 'cupertinos_bottom_navigation_scaffold.dart';
import 'materials_bottom_navigation_scaffold.dart';

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

  void _onTabSelected(int newIndex) {
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
            ? MaterialBottomNavigationScaffold(
                navigationBarItems: widget.navigationBarItems,
                onItemSelected: _onTabSelected,
                selectedIndex: _currentlySelectedIndex,
              )
            : CupertinoBottomNavigationScaffold(
                navigationBarItems: widget.navigationBarItems,
                onItemSelected: _onTabSelected,
                selectedIndex: _currentlySelectedIndex,
              ),
      );
}
