import 'package:flutter/material.dart';

import 'package:tokenlab_challenge/ui/components/image_loader.dart';
import 'package:tokenlab_challenge/ui/components/indicators/favorite_indicator.dart';
import 'package:tokenlab_challenge/ui/components/movies_structure_type.dart';
import 'package:tokenlab_challenge/ui/components/page_navigation.dart';

class MoviesListStructure extends StatefulWidget {
  const MoviesListStructure(
      {@required this.moviesList,
      @required this.movieStructureType,
      @required this.favoritesList,
      @required this.onFavoriteTapStreamSink,
      Key key})
      : assert(moviesList != null),
        assert(movieStructureType != null),
        assert(favoritesList != null),
        assert(onFavoriteTapStreamSink != null),
        super(key: key);

  final List<int> favoritesList;
  final Sink<int> onFavoriteTapStreamSink;
  final List moviesList;
  final MovieStructureType movieStructureType;

  @override
  _MoviesListStructureState createState() => _MoviesListStructureState();
}

class _MoviesListStructureState extends State<MoviesListStructure> {
  SliverChildBuilderDelegate _buildSliverChildDelegate(BuildContext context) =>
      SliverChildBuilderDelegate(
        (context, index) => FlatButton(
          onPressed: () =>
              pushPage(context, true, arguments: widget.moviesList[index].id),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ImageLoader(
                  title: widget.moviesList[index].title,
                  url: widget.moviesList[index].posterUrl,
                  titleStyle: Theme.of(context).textTheme.headline1,
                ),
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: FavoriteIndicator(
                    isFavorite: widget.favoritesList
                        .contains(widget.moviesList[index].id),
                    onFavoriteTap: () => widget.onFavoriteTapStreamSink
                        .add(widget.moviesList[index].id),
                  )),
            ],
          ),
        ),
        childCount: widget.moviesList.length,
      );

  @override
  Widget build(BuildContext context) =>
      widget.movieStructureType == MovieStructureType.list
          ? SliverList(
              delegate: _buildSliverChildDelegate(context),
            )
          : SliverGrid(
              delegate: _buildSliverChildDelegate(context),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
            );
}

// final _bloc = FavoriteItemBloc(
//     movieId: widget.moviesList[index].id,
//     movieName: widget.moviesList[index].title);
