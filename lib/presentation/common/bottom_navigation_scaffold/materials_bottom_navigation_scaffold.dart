import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tokenlab_challenge/presentation/common/bottom_navigator_tab.dart';

class MaterialBottomNavigationScaffold extends StatefulWidget {
  const MaterialBottomNavigationScaffold({
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
  _MaterialBottomNavigationScaffoldState createState() =>
      _MaterialBottomNavigationScaffoldState();
}

class _MaterialBottomNavigationScaffoldState
    extends State<MaterialBottomNavigationScaffold>
    with TickerProviderStateMixin<MaterialBottomNavigationScaffold> {
  final List<_MaterialBottomNavigationTab> materialNavigationBarItems = [];
  final List<AnimationController> _animationControllers = [];
  final List<bool> _shouldBuildTab = <bool>[];

  @override
  void initState() {
    _initAnimationControllers();
    _initMaterialNavigationBarItems();

    _shouldBuildTab.addAll(
      List<bool>.filled(
        widget.navigationBarItems.length,
        false,
      ),
    );

    super.initState();
  }

  void _initMaterialNavigationBarItems() {
    materialNavigationBarItems.addAll(
      widget.navigationBarItems
          .map(
            (barItem) => _MaterialBottomNavigationTab(
              bottomNavigationBarItem: barItem.bottomNavigationBarItem,
              navigatorKey: barItem.navigatorKey,
              subtreeKey: GlobalKey(),
              initialRouteName: barItem.initialRouteName,
            ),
          )
          .toList(),
    );
  }

  void _initAnimationControllers() {
    _animationControllers.addAll(
      widget.navigationBarItems.map<AnimationController>(
        (destination) => AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 200),
        ),
      ),
    );

    if (_animationControllers.isNotEmpty) {
      _animationControllers[0].value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationControllers.forEach(
      (controller) => controller.dispose(),
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: materialNavigationBarItems
              .map(
                (barItem) => PageFlowBuilder(
                  animationControllers: _animationControllers,
                  shouldBuildTab: _shouldBuildTab,
                  selectedIndex: widget.selectedIndex,
                  tabIndex: materialNavigationBarItems.indexOf(barItem),
                  item: barItem,
                ),
              )
              .toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.selectedIndex,
          items: materialNavigationBarItems
              .map((item) => item.bottomNavigationBarItem)
              .toList(),
          onTap: widget.onItemSelected,
        ),
      );
}

class PageFlowBuilder extends StatelessWidget {
  const PageFlowBuilder({
    @required this.animationControllers,
    @required this.shouldBuildTab,
    @required this.selectedIndex,
    @required this.tabIndex,
    @required this.item,
  })  : assert(animationControllers != null),
        assert(shouldBuildTab != null),
        assert(selectedIndex != null),
        assert(tabIndex != null),
        assert(item != null);

  final List<AnimationController> animationControllers;
  final List<bool> shouldBuildTab;
  final int selectedIndex;
  final int tabIndex;
  final _MaterialBottomNavigationTab item;

  @override
  Widget build(BuildContext context) {
    final isCurrentlySelected = tabIndex == selectedIndex;

    shouldBuildTab[tabIndex] = isCurrentlySelected || shouldBuildTab[tabIndex];

    final Widget view = FadeTransition(
      opacity: animationControllers[tabIndex].drive(
        CurveTween(curve: Curves.fastOutSlowIn),
      ),
      child: KeyedSubtree(
        key: item.subtreeKey,
        child: shouldBuildTab[tabIndex]
            ? Navigator(
                key: item.navigatorKey,
                initialRoute: item.initialRouteName,
                onGenerateRoute:
                    Provider.of<RouteFactory>(context, listen: false),
              )
            : Container(),
      ),
    );

    if (tabIndex == selectedIndex) {
      animationControllers[tabIndex].forward();
      return view;
    } else {
      animationControllers[tabIndex].reverse();
      if (animationControllers[tabIndex].isAnimating) {
        return IgnorePointer(child: view);
      }
      return Offstage(child: view);
    }
  }
}

class _MaterialBottomNavigationTab extends BottomNavigationTab {
  _MaterialBottomNavigationTab({
    @required this.subtreeKey,
    @required BottomNavigationBarItem bottomNavigationBarItem,
    @required GlobalKey<NavigatorState> navigatorKey,
    @required String initialRouteName,
  })  : assert(subtreeKey != null),
        assert(bottomNavigationBarItem != null),
        assert(navigatorKey != null),
        assert(initialRouteName != null),
        super(
          bottomNavigationBarItem: bottomNavigationBarItem,
          navigatorKey: navigatorKey,
          initialRouteName: initialRouteName,
        );

  final GlobalKey subtreeKey;
}
