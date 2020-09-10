import 'package:flutter/material.dart';
import 'package:tokenlab_challenge/data/movies_repository.dart';

class FavoritesListScreen extends StatefulWidget {
  @override
  _FavoritesListScreenState createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {
  final _repository = MoviesRepository();
  List<int> favoritesList;

  @override
  void initState() {
    _repository.getFavorites().then((list) => favoritesList = list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView.builder(
          itemBuilder: (context, index) => ListTile(
            leading: Text('${favoritesList[index]}'),
          ),
        ),
      );
}
