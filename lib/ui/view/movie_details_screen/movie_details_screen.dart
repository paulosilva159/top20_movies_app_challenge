import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tokenlab_challenge/bloc/movie_details_bloc.dart';
import 'package:tokenlab_challenge/ui/view/movie_details_screen/movie_details_screen_state.dart';

// import '../../../data/dio/dio_client.dart';
// import '../../../data/model/model.dart';

import '../../../generated/l10n.dart';

import 'movie_details_tile.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({@required this.id, Key key})
      : assert(id != null),
        super(key: key);

  final int id;

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  MovieDetailsBloc _bloc;

  @override
  void initState() {
    _bloc = MovieDetailsBloc(movieId: widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: _bloc.onNewState,
        builder: (context, snapshot) => Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).detailsScreenTopTitle),
            centerTitle: true,
          ),
          body: _MovieDetailsBody(
              movieDetailsBodyState: snapshot,
              getMovieDetails: () => _bloc.onTryAgain.add(null)),
        ),
      );

  // MovieLongDetails _movieDetails;
  // bool _awaitingMovieDetails;

  // dynamic _error;
  // final _dio = DioClient();
  //
  // void _getMovieDetails() {
  //   setState(() {
  //     _error = null;
  //     _awaitingMovieDetails = true;
  //   });
  //
  //   _dio.getMovieDetails(widget.id).then((movieDetails) {
  //     setState(() {
  //       _movieDetails = movieDetails;
  //       _awaitingMovieDetails = false;
  //     });
  //   }).catchError((error) {
  //     setState(() {
  //       _error = error.error;
  //       _awaitingMovieDetails = false;
  //     });
  //   });
  // }
  //
  // @override
  // void didChangeDependencies() {
  //   _getMovieDetails();
  //
  //   super.didChangeDependencies();
  // }

  // @override
  // Widget build(BuildContext context) => Scaffold(
  //       appBar: AppBar(
  //         title: Text(S.of(context).detailsScreenTopTitle),
  //         centerTitle: true,
  //       ),
  //       body: _MovieDetailsBody(
  //         error: _error,
  //         movieDetails: _movieDetails,
  //         awaitingMovieDetails: _awaitingMovieDetails,
  //         getMovieDetails: () {
  //           _getMovieDetails();
  //         },
  //       ),
  //     );

}

class _MovieDetailsBody extends StatelessWidget {
  const _MovieDetailsBody({
    @required this.movieDetailsBodyState,
    @required this.getMovieDetails,
  })  : assert(movieDetailsBodyState != null),
        assert(getMovieDetails != null);

  final AsyncSnapshot movieDetailsBodyState;
  final VoidCallback getMovieDetails;

  @override
  Widget build(BuildContext context) {
    if (movieDetailsBodyState.data is Loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (movieDetailsBodyState.data is Error) {
      return Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            if (movieDetailsBodyState.data.error is SocketException)
              Text(
                S.of(context).connectionErrorMessage,
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              )
            else
              Text(
                S.of(context).genericErrorMessage,
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            RaisedButton(
              onPressed: getMovieDetails,
              child: Text(S.of(context).tryAgainMessage),
            ),
          ],
        ),
      );
    } else {
      return MovieDetailsTile(
        movieDetails: movieDetailsBodyState.data.movieDetails,
      );
    }
  }
}
