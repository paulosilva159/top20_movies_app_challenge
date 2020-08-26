import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../data/model/model.dart';

import '../../../../routes/routes.dart';

import '../../../components/image_loader.dart';

class MoviesList extends StatelessWidget {
  const MoviesList({@required this.moviesList}) : assert(moviesList != null);

  final List<MovieShortDetails> moviesList;

  @override
  Widget build(BuildContext context) => SliverList(
        delegate: SliverChildBuilderDelegate(
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
        ),
      );
}
