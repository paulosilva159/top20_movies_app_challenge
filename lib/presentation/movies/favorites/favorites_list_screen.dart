import 'package:domain/use_case/get_favorites_list_uc.dart';
import 'package:flutter/material.dart';

import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';

import 'package:tokenlab_challenge/generated/l10n.dart';
import 'package:tokenlab_challenge/presentation/common/async_snapshot_response_view.dart';
import 'package:tokenlab_challenge/presentation/common/indicators/indicators.dart';
import 'package:tokenlab_challenge/presentation/common/page_navigation.dart';

import 'favorites_list_bloc.dart';
import 'favorites_list_screen_state.dart';

class FavoritesListScreen extends StatelessWidget {
  FavoritesListScreen({@required this.bloc}) : assert(bloc != null);

  final FavoritesListBloc bloc;

  final _focusDetectorKey = UniqueKey();

  static Widget create() =>
      ProxyProvider<GetFavoritesListUC, FavoritesListBloc>(
        update: (context, getFavoritesList, favoritesListBloc) =>
            favoritesListBloc ??
            FavoritesListBloc(getFavoritesList: getFavoritesList),
        dispose: (context, bloc) => bloc.dispose(),
        child: Consumer<FavoritesListBloc>(
          builder: (context, bloc, child) => FavoritesListScreen(
            bloc: bloc,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => FocusDetector(
        key: _focusDetectorKey,
        onFocusGained: () => bloc.onFocusGain.add(null),
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).favoritesListScreenTitle),
            centerTitle: true,
          ),
          body: StreamBuilder<FavoritesListScreenState>(
            stream: bloc.onNewState,
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
                onTryAgainTap: () => bloc.onTryAgain.add(null),
              ),
            ),
          ),
        ),
      );
}
