import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MovieIndexedPage extends StatelessWidget {
  const MovieIndexedPage({
    @required this.index,
    @required this.containingFlowTitle,
    Key key,
  })  : assert(index != null),
        super(key: key);

  final int index;
  final String containingFlowTitle;

  //  @override
//  Widget build(BuildContext context) => Scaffold(
//        body: CustomScrollView(
//          slivers: [
//            SliverAppBar(
//              expandedHeight: 250,
//              flexibleSpace: FlexibleSpaceBar(
//                title: const Text('TMDb'),
//                centerTitle: true,
//                background: Padding(
//                  padding: const EdgeInsets.all(20),
//                  child: Image.asset('lib/ui/assets/top-20.png'),
//                ),
//              ),
//            ),
//            MoviesContentBody(
//              error: _error,
//              moviesList: _moviesList,
//              awaitingMoviesList: _awaitingMoviesList,
//              onTryAgainTap: () {
//                _getMovies();
//              },
//            ),
//          ],
//        ),
//      );

  @override
  Widget build(BuildContext context) {
    var pageTitle = 'Page $index';
    if (containingFlowTitle != null) {
      pageTitle += ' of $containingFlowTitle Flow';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitle,
          maxLines: 1,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Horizontally pushes a new screen.
            RaisedButton(
              onPressed: () {
                _pushPage(context, true);
              },
              child: const Text('NEXT PAGE (HORIZONTALLY)'),
            ),

            // Vertically pushes a new screen / Starts a new flow.
            // In a real world scenario, this could be an authentication flow
            // where the user can choose to sign in or sign up.
            RaisedButton(
              onPressed: () {
                _pushPage(context, false);
              },
              child: const Text('NEXT FLOW (VERTICALLY)'),
            ),
          ],
        ),
      ),
    );
  }

  void _pushPage(BuildContext context, bool isHorizontalNavigation) {
    // If it's not horizontal navigation,
    // we should use the rootNavigator.
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => MovieIndexedPage(
          // If it's a new flow, the displayed index should be 1 again.
          index: isHorizontalNavigation ? index + 1 : 1,
          containingFlowTitle:
              isHorizontalNavigation ? containingFlowTitle : 'New',
        ),
        fullscreenDialog: !isHorizontalNavigation,
      ),
    );
  }

  PageRoute<T> _buildAdaptivePageRoute<T>({
    @required WidgetBuilder builder,
    bool fullscreenDialog = false,
  }) =>
      Platform.isAndroid
          ? MaterialPageRoute(
              builder: builder,
              fullscreenDialog: fullscreenDialog,
            )
          : CupertinoPageRoute(
              builder: builder,
              fullscreenDialog: fullscreenDialog,
            );
}
