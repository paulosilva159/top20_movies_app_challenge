import 'package:flutter/material.dart';

import 'package:tokenlab_challenge/bloc/favorites_list_bloc.dart';
import 'package:tokenlab_challenge/ui/components/indicators/indicators.dart';
import 'package:tokenlab_challenge/ui/components/page_navigation.dart';
import 'package:tokenlab_challenge/ui/view/favorites_screen/favorites_list_screen_state.dart';

class FavoritesListScreen extends StatefulWidget {
  @override
  _FavoritesListScreenState createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {
  final _bloc = FavoritesListBloc();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: StreamBuilder<FavoritesListScreenState>(
        stream: _bloc.onNewState,
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
              itemBuilder: (context, index) {
                final id = stateData.favorites.keys.toList()[index];
                final title = stateData.favorites.values.toList()[index];

                return ListTile(
                  leading: Text('#$id'),
                  title: Text(
                    '$title',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () => pushPage(context, true, arguments: id),
                );
              },
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
