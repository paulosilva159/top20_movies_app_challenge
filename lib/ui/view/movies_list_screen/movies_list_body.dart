import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/model/model.dart';

import '../../components/movies_structure.dart';

class MoviesContentBody extends StatelessWidget {
  const MoviesContentBody({
    @required this.movieStructureType,
    @required this.awaitingMoviesList,
    @required this.onTryAgainTap,
    this.error,
    this.moviesList,
  })  : assert(movieStructureType != null),
        assert(awaitingMoviesList != null),
        assert(onTryAgainTap != null);

  final dynamic error;
  final MovieStructureType movieStructureType;
  final List<MovieShortDetails> moviesList;
  final bool awaitingMoviesList;
  final VoidCallback onTryAgainTap;

  @override
  Widget build(BuildContext context) {
    if (awaitingMoviesList) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (error != null) {
      return SliverFillRemaining(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            if (error is SocketException)
              const Text(
                'Verifique sua conexão',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              )
            else
              const Text(
                'Error',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            RaisedButton(
              onPressed: onTryAgainTap,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    } else {
      return MoviesStructure(
        moviesList: moviesList,
        movieStructureType: movieStructureType,
      );
    }
  }
}
