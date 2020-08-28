import 'package:flutter/material.dart';

import '../../../../data/model/model.dart';

import '../../../../routes/routes.dart';

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
            Navigator.pushNamed(context, Routes.details,
                arguments: moviesList[index].id);
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
}

enum MovieStructureType {
  grid,
  list,
}
