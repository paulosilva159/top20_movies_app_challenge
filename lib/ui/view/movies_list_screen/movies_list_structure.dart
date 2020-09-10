import 'package:flutter/material.dart';

import 'package:tokenlab_challenge/ui/components/image_loader.dart';
import 'package:tokenlab_challenge/ui/components/indicators/favorite_indicator.dart';
import 'package:tokenlab_challenge/ui/components/movies_structure_type.dart';
import 'package:tokenlab_challenge/ui/components/page_navigation.dart';

class MoviesListStructure extends StatelessWidget {
  const MoviesListStructure({
    @required this.moviesList,
    @required this.movieStructureType,
  })  : assert(moviesList != null),
        assert(movieStructureType != null);

  final List moviesList;
  final MovieStructureType movieStructureType;

  SliverChildBuilderDelegate _buildSliverChildDelegate(BuildContext context) =>
      SliverChildBuilderDelegate(
        (context, index) => FlatButton(
          onPressed: () {
            pushPage(context, true, arguments: moviesList[index].id);
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ImageLoader(
                  title: moviesList[index].title,
                  url: moviesList[index].posterUrl,
                  titleStyle: Theme.of(context).textTheme.headline1,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: FavoriteIndicator(
                  movieId: moviesList[index].id,
                  movieName: moviesList[index].title,
                ),
              ),
            ],
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
