import 'package:flutter/material.dart';

import '../../../data/dio/dio_client.dart';
import '../../../data/model/model.dart';

import 'components/movies_list.dart';

class MoviesListScreen extends StatefulWidget {
  @override
  _MoviesListScreenState createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  final _moviesList = <MovieShortDetails>[];
  bool _shouldRetry = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('TMDb'),
                centerTitle: true,
                background: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset('lib/ui/assets/top-20.png'),
                ),
              ),
            ),
            if (!_shouldRetry && _moviesList.isNotEmpty)
              MoviesList(_moviesList),
            if (_shouldRetry || _moviesList.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: RaisedButton(
                    onPressed: () {
                      DioClient().getMovies().then((value) {
                        setState(() {
                          if (value.isEmpty) {
                            _shouldRetry = true;
                          } else {
                            _shouldRetry = false;
                          }

                          if (_moviesList.isEmpty) {
                            _moviesList.addAll(value);
                          } else {
                            _moviesList.setAll(0, value);
                          }
                        });
                      });
                    },
                    child: Text(!_shouldRetry && _moviesList == null
                        ? 'Buscar filmes'
                        : 'Tentar Novamente'),
                  ),
                ),
              ),
          ],
        ),
      );
}
