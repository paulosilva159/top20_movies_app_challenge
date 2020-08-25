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
  List<MovieShortDetails> _moviesList;
  bool _awaitingMovieList = true;

  final _dio = DioClient();
  dynamic _error;

  void _getMovies({bool isRetrying = false}) {
    setState(() {
      _error = null;
      _awaitingMovieList = true;
    });

    _dio.getMovies().then((value) {
      setState(() {
        if (isRetrying) {
          _error = null;
        }
        _moviesList = value;
        _awaitingMovieList = false;
      });
    }).catchError((error) {
      setState(() {
        _error = error.error;
      });
    });
  }

  @override
  void initState() {
    _getMovies();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        elevation: 20,
        toolbarHeight: 250,
        title: Padding(
          padding: const EdgeInsets.all(70),
          child: Image.asset('lib/ui/assets/top-20.png'),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Stack(
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
                        _getMovies(isRetrying: true);
                      },
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              )
            else if (_awaitingMovieList)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              MoviesList(_moviesList)
          ],
        ),
      ));
}
