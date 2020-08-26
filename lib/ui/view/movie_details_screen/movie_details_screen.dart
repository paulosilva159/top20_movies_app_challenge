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
  MovieLongDetails _detailsContent;
  bool _awaitingDetailsContent;
  int _id;

  dynamic _error;
  final _dio = DioClient();

  void _getMovieDetails() {
    setState(() {
      _error = null;
      _awaitingDetailsContent = true;
    });

    _dio.getMovieDetails(_id).then((movieDetails) {
      setState(() {
        _detailsContent = movieDetails;
        _awaitingDetailsContent = false;
      });
    }).catchError((error) {
      setState(() {
        _error = error.error;
        print(_error);
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (_id == null) {
      _id = ModalRoute.of(context).settings.arguments;

      _getMovieDetails();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget _body;

    if (_error != null) {
      _body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          if (_error is SocketException)
            const Text(
              'Verifique sua conexão',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
            )
          else
            const Text(
              'Erro!',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          RaisedButton(
            onPressed: () {
              _getMovieDetails();
            },
            child: const Text('Tentar Novamente'),
          ),
        ],
      );
    } else if (_awaitingDetailsContent) {
      _body = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      _body = MovieDetailsTile(detailsContent: _detailsContent);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        centerTitle: true,
      ),
      body: _body,
    );
  }
}
