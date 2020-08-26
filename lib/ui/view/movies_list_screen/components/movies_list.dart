import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../data/model/model.dart';

import '../../../../routes/routes.dart';

import '../../../components/image_loader.dart';

class MoviesList extends StatelessWidget {
  const MoviesList({@required this.movieList}) : assert(movieList != null);

  final List<MovieShortDetails> movieList;

  @override
  Widget build(BuildContext context) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.details,
                  arguments: movieList[index].id);
            },
            child: ImageLoader(
              title: movieList[index].title,
              url: movieList[index].posterUrl,
              titleStyle: Theme.of(context).textTheme.headline1,
            ),
          ),
          childCount: movieList.length,
        ),
      );
}
