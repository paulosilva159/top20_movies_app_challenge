import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/model/model.dart';

import 'image_loader.dart';
import 'page_navigation.dart';

class MoviesStructure extends StatelessWidget {
  const MoviesStructure({
    @required this.moviesList,
    @required this.movieStructureType,
  })  : assert(moviesList != null),
        assert(movieStructureType != null);

  final List<MovieShortDetailsRM> moviesList;
  final MovieStructureType movieStructureType;

  SliverChildBuilderDelegate _buildSliverChildDelegate(BuildContext context) =>
      SliverChildBuilderDelegate(
        (context, index) => FlatButton(
          onPressed: () {
            pushPage(context, true, arguments: moviesList[index].id);
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
          : SliverGrid(
              delegate: _buildSliverChildDelegate(context),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
            );
}

enum MovieStructureType {
  grid,
  list,
}
