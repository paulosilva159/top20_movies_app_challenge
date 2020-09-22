import 'package:flutter/material.dart';

import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';

import 'package:tokenlab_challenge/data/repository/movies_repository.dart';

import 'package:tokenlab_challenge/generated/l10n.dart';
import 'package:tokenlab_challenge/presentation/common/async_snapshot_response_view.dart';
import 'package:tokenlab_challenge/presentation/common/indicators/indicators.dart';
import 'package:tokenlab_challenge/presentation/common/page_navigation.dart';

import 'favorites_list_bloc.dart';
import 'favorites_list_screen_state.dart';

class FavoritesListScreen extends StatefulWidget {
  const FavoritesListScreen({@required this.bloc}) : assert(bloc != null);

  final FavoritesListBloc bloc;

  static Widget create() => ProxyProvider<MoviesRepository, FavoritesListBloc>(
        update: (context, moviesRepository, favoritesListBloc) =>
            FavoritesListBloc(repository: moviesRepository),
        child: Consumer<FavoritesListBloc>(
          builder: (context, bloc, child) => FavoritesListScreen(
            bloc: bloc,
          ),
        ),
      );

  @override
  _FavoritesListScreenState createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {
  final _focusDetectorKey = UniqueKey();

  @override
  Widget build(BuildContext context) => FocusDetector(
        key: _focusDetectorKey,
        onFocusGained: () => widget.bloc.onFocusGain.add(null),
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).favoritesListScreenTitle),
            centerTitle: true,
          ),
          body: StreamBuilder<FavoritesListScreenState>(
            stream: widget.bloc.onNewState,
            builder: (context, snapshot) =>
                AsyncSnapshotResponseView<Loading, Error, Success>(
              snapshot: snapshot,
              loadingWidgetBuilder: (context, stateData) => LoadingIndicator(),
              successWidgetBuilder: (context, stateData) => ListView.builder(
                itemBuilder: (context, index) {
                  final id = stateData.favorites[index].id;
                  final title = stateData.favorites[index].title;

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
              ),
              errorWidgetBuilder: (context, stateData) => ErrorIndicator(
                type: stateData.type,
                onTryAgainTap: () => widget.bloc.onTryAgain.add(null),
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}
