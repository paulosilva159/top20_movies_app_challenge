import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tokenlab_challenge/ui/view/movie_details_screen/movie_details_screen.dart';

import '../../../../data/model/model.dart';

import '../../../components/image_loader.dart';

class MoviesStructure extends StatelessWidget {
  const MoviesStructure(
      {@required this.moviesList, @required this.movieStructureType})
      : assert(moviesList != null),
        assert(movieStructureType != null);

  final List<MovieShortDetails> moviesList;
  final MovieStructureType movieStructureType;

  SliverChildBuilderDelegate sliverBuilder(BuildContext context) =>
      SliverChildBuilderDelegate(
        (context, index) => FlatButton(
          onPressed: () {
            /// TODO: implementar trocar de página aqui
//            Navigator.pushNamed(context, Routes.details,
//                arguments: moviesList[index].id);
          },
          child: ImageLoader(
            title: moviesList[index].title,
            url: moviesList[index].posterUrl,
            titleStyle: Theme.of(context).textTheme.headline1,
          ),
        ),
        childCount: moviesList.length,
      );

  @override
  Widget build(BuildContext context) =>
      movieStructureType == MovieStructureType.list
          ? SliverList(
              delegate: sliverBuilder(context),
            )
          : SliverGrid(
              delegate: sliverBuilder(context),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
            );

  PageRoute<T> _buildAdaptivePageRoute<T>({
    @required WidgetBuilder builder,
    bool fullscreenDialog = false,
    int movieId,
  }) =>
      Platform.isAndroid
          ? MaterialPageRoute(
              settings: RouteSettings(arguments: movieId),
              builder: builder,
              fullscreenDialog: fullscreenDialog,
            )
          : CupertinoPageRoute(
              settings: RouteSettings(arguments: movieId),
              builder: builder,
              fullscreenDialog: fullscreenDialog,
            );

  void _pushPage(
      BuildContext context, bool isHorizontalNavigation, int movieId) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
//        builder: (context) => MovieIndexedPage(
//          // If it's a new flow, the displayed index should be 1 again.
//          index: isHorizontalNavigation ? index + 1 : 1,
//          containingFlowTitle:
//              isHorizontalNavigation ? containingFlowTitle : 'New',
//        ),
        builder: (context) => MovieDetailsScreen(),
        fullscreenDialog: !isHorizontalNavigation,
        movieId: movieId,
      ),
    );
  }
}

enum MovieStructureType {
  grid,
  list,
}
