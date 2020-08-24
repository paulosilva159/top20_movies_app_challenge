import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/dio/dio_client.dart';
import '../../../data/model/model.dart';

import 'components/movie_details_tile.dart';

class MovieDetailsScreen extends StatefulWidget {
  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  MovieLongDetails _detailsContent = MovieLongDetails();
  bool _awaitingDetailsContent = true;
  int _id;

  dynamic _error;
  final _dio = DioClient();

  @override
  void didChangeDependencies() {
    if (_id == null) {
      _id = ModalRoute.of(context).settings.arguments;

      _dio.getMovieDetails(_id).then((value) {
        setState(() {
          _detailsContent = value;
          _awaitingDetailsContent = false;
        });
      }).catchError((error) {
        setState(() {
          _error = error.error;
          print(_error);
        });
      });
    }

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
                        _dio.getMovieDetails(_id).then((value) {
                          setState(() {
                            _error = null;
                            _detailsContent = value;
                            _awaitingDetailsContent = false;
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
              visible: !_awaitingDetailsContent,
              replacement: const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              child: MovieDetailsTile(_detailsContent),
            ),
        ],
      ));
}
