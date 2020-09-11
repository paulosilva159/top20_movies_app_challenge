import 'package:flutter/material.dart';

import 'package:tokenlab_challenge/bloc/favorite_item_bloc.dart';

import 'package:tokenlab_challenge/ui/components/image_loader.dart';
import 'package:tokenlab_challenge/ui/components/indicators/favorite_indicator.dart';
import 'package:tokenlab_challenge/ui/components/movies_structure_type.dart';
import 'package:tokenlab_challenge/ui/components/page_navigation.dart';

class MoviesListStructure extends StatefulWidget {
  const MoviesListStructure(
      {@required this.moviesList, @required this.movieStructureType, Key key})
      : assert(moviesList != null),
        assert(movieStructureType != null),
        super(key: key);

  final List moviesList;
  final MovieStructureType movieStructureType;

  @override
  _MoviesListStructureState createState() => _MoviesListStructureState();
}

class _MoviesListStructureState extends State<MoviesListStructure> {
  SliverChildBuilderDelegate _buildSliverChildDelegate(BuildContext context) =>
      SliverChildBuilderDelegate(
        (context, index) {
          final _bloc = FavoriteItemBloc(
              movieId: widget.moviesList[index].id,
              movieName: widget.moviesList[index].title);

          return FlatButton(
            onPressed: () {
              pushPage(context, true, arguments: widget.moviesList[index].id);
            },
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
                  child: StreamBuilder<bool>(
                      stream: _bloc.onNewState,
                      builder: (context, snapshot) => FavoriteIndicator(
                            isFavorite: snapshot.data,
                            onFavoriteTap: () => _bloc.onFavoriteTap.add(null),
                          )),
                ),
              ],
            ),
          );
        },
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
