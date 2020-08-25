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

  void _getMovieDetails({bool isRetrying = false}) {
    setState(() {
      _error = null;
      _awaitingDetailsContent = true;
    });

    _dio.getMovieDetails(_id).then((value) {
      setState(() {
        if (isRetrying) {
          _error = null;
        }
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

  @override
  void didChangeDependencies() {
    if (_id == null) {
      _id = ModalRoute.of(context).settings.arguments;

      _getMovieDetails();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            if (_error != null)
              Center(
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
                        _getMovieDetails(isRetrying: true);
                      },
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              )
            else if (_awaitingDetailsContent)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              MovieDetailsTile(_detailsContent)
          ],
        ),
      );
}
