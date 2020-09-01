import 'package:flutter/material.dart';

class MoviesListScreen extends StatefulWidget {
  @override
  _MoviesListScreenState createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  @override
  Widget build(BuildContext context) => Container();
}

// Scaffold(
// body: CustomScrollView(
// slivers: [
// SliverAppBar(
// actions: [
// IconButton(
// onPressed: () {
// pushPage(context, false);
// },
// icon: const Icon(Icons.vertical_align_top),
// )
// ],
// expandedHeight: 250,
// flexibleSpace: FlexibleSpaceBar(
// title: const Text('TMDb'),
// centerTitle: true,
// background: Padding(
// padding: const EdgeInsets.all(20),
// child: Image.asset('lib/ui/assets/top-20.png'),
// ),
// ),
// ),
// MoviesContentBody(
// movieStructureType: flow.movieStructureType,
// error: _error,
// moviesList: _moviesList,
// awaitingMoviesList: _awaitingMoviesList,
// onTryAgainTap: () {
// _getMovies();
// },
// ),
// ],
// ),
// ),
