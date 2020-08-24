import 'dart:io';

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
  bool _awaitingMovieList = true;

  final _dio = DioClient();
  dynamic _error;

  @override
  void initState() {
    _dio.getMovies().then((value) {
      setState(() {
        _moviesList.addAll(value);
        _awaitingMovieList = false;
      });
    }).catchError((error) {
      setState(() {
        _error = error.error;
      });
    });

    super.initState();
  }

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
            if (_error != null)
              SliverToBoxAdapter(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      if (_error is SocketException)
                        const Text(
                          'Verifique sua conexão',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      RaisedButton(
                        onPressed: () {
                          _dio.getMovies().then((value) {
                            setState(() {
                              _error = null;
                              _moviesList.addAll(value);
                              _awaitingMovieList = false;
                            });
                          }).catchError((onError) {
                            setState(() {
                              _error = onError;
                            });
                          });
                        },
                        child: const Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                ),
              ),
            if (_error == null)
              Visibility(
                visible: !_awaitingMovieList,
                replacement: const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                child: MoviesList(_moviesList),
              ),
          ],
        ),
      );
}
