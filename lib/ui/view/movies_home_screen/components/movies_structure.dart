import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../data/model/model.dart';

import '../../../../ui/components/image_loader.dart';

import '../../movie_details_screen/movie_details_screen.dart';

class MoviesStructure extends StatelessWidget {
  const MoviesStructure({
    @required this.moviesList,
    @required this.movieStructureType,
  })  : assert(moviesList != null),
        assert(movieStructureType != null);

  final List<MovieShortDetails> moviesList;
  final MovieStructureType movieStructureType;

  SliverChildBuilderDelegate _buildSliverChildDelegate(BuildContext context) =>
      SliverChildBuilderDelegate(
        (context, index) => FlatButton(
          onPressed: () {
            _pushPage(context, true, movieId: moviesList[index].id);
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
              delegate: _buildSliverChildDelegate(context),
            )
          : movieStructureType == MovieStructureType.grid
              ? SliverGrid(
                  delegate: _buildSliverChildDelegate(context),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                )
              : SliverFillRemaining(
                  child: Center(
                    child: RaisedButton(
                      onPressed: () {
                        _pushPage(
                          context,
                          false,
                        );
                      },
                      child: const Text('Vertical'),
                    ),
                  ),
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

  void _pushPage(BuildContext context, bool isHorizontalNavigation,
      {int movieId}) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
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
  vertical,
}
