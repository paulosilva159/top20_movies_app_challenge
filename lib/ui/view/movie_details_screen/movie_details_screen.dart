import 'package:flutter/material.dart';

import '../../../data/dio/dio_client.dart';
import '../../../data/model/model.dart';

import 'components/movie_details_tile.dart';

class MovieDetailsScreen extends StatefulWidget {
  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  MovieLongDetails _detailsContent;
  bool _shouldRetry = false;
  int _id;

  @override
  void didChangeDependencies() {
    _id = ModalRoute.of(context).settings.arguments;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Detalhes'),
            ),
          ),
          if (!_shouldRetry && _detailsContent != null)
            MovieDetailsTile(_detailsContent),
          if (_shouldRetry || _detailsContent == null)
            SliverToBoxAdapter(
              child: Center(
                child: RaisedButton(
                  onPressed: () {
                    DioClient().getMovieDetails(_id).then((value) {
                      setState(() {
                        if (value == null) {
                          _shouldRetry = true;
                        } else {
                          _shouldRetry = false;

                          _detailsContent = value;
                        }
                      });
                    });
                  },
                  child: Text(!_shouldRetry && _detailsContent == null
                      ? 'Buscar filmes'
                      : 'Tentar Novamente'),
                ),
              ),
            ),
        ],
      ));
}
