import 'package:flutter/material.dart';
import 'package:tokenlab_challenge/data/model/model.dart';

import 'package:tokenlab_challenge/ui/components/image_loader.dart';
import 'package:tokenlab_challenge/ui/components/indicators/favorite_indicator.dart';
import 'package:tokenlab_challenge/ui/components/movies_structure_type.dart';
import 'package:tokenlab_challenge/ui/components/page_navigation.dart';

class MoviesListStructure extends StatelessWidget {
  const MoviesListStructure({
    @required this.moviesList,
    @required this.movieStructureType,
    @required this.favoritesList,
    @required this.onFavoriteTapCallback,
  })  : assert(moviesList != null),
        assert(movieStructureType != null),
        assert(favoritesList != null),
        assert(onFavoriteTapCallback != null);

  final List<int> favoritesList;
  final void Function(int movieId) onFavoriteTapCallback;
  final List<MovieShortDetailsCM> moviesList;
  final MovieStructureType movieStructureType;

  SliverChildBuilderDelegate _buildSliverChildDelegate(BuildContext context) =>
      SliverChildBuilderDelegate(
        (context, index) => FlatButton(
          onPressed: () =>
              pushPage(context, true, arguments: moviesList[index].id),
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
                    isFavorite: favoritesList.contains(moviesList[index].id),
                    onFavoriteTap: () =>
                        onFavoriteTapCallback(moviesList[index].id),
                  )),
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
