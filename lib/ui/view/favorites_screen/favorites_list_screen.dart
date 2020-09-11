import 'package:flutter/material.dart';

import 'package:tokenlab_challenge/bloc/favorites_list_bloc.dart';
import 'package:tokenlab_challenge/ui/components/indicators/indicators.dart';
import 'package:tokenlab_challenge/ui/view/favorites_screen/favorites_list_screen_state.dart';

class FavoritesListScreen extends StatefulWidget {
  @override
  _FavoritesListScreenState createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {
  final _bloc = FavoritesListBloc();

  @override
  Widget build(BuildContext context) => Scaffold(
          body: StreamBuilder<FavoritesListScreenState>(
        stream: null,
        builder: (context, snapshot) {
          final stateData = snapshot.data;

          if (stateData == null || stateData is Loading) {
            return LoadingIndicator();
          } else if (stateData is Error) {
            return ErrorIndicator(
              error: stateData.error,
              onTryAgainTap: () => _bloc.onTryAgain.add(null),
            );
          } else if (stateData is Success) {
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                  title: Text('${stateData.favorites.keys.toList()[index]}')),
              itemCount: stateData.favorites.length,
            );
          }

          throw Exception();
        },
      ));

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
