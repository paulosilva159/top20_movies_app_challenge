import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';

import 'package:tokenlab_challenge/bloc/favorites_list_bloc.dart';

import 'package:tokenlab_challenge/generated/l10n.dart';
import 'package:tokenlab_challenge/ui/components/async_snapshot_response_view.dart';

import 'package:tokenlab_challenge/ui/components/indicators/indicators.dart';
import 'package:tokenlab_challenge/ui/components/page_navigation.dart';
import 'package:tokenlab_challenge/ui/view/favorites_screen/favorites_list_screen_state.dart';

class FavoritesListScreen extends StatefulWidget {
  @override
  _FavoritesListScreenState createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {
  final _bloc = FavoritesListBloc();
  final _focusDetectorKey = UniqueKey();

  @override
  Widget build(BuildContext context) => FocusDetector(
        key: _focusDetectorKey,
        onFocusGained: () => _bloc.onFocusGain.add(null),
        child: Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).favoritesListScreenTitle),
              centerTitle: true,
            ),
            body: StreamBuilder<FavoritesListScreenState>(
              stream: _bloc.onNewState,
              builder: (context, snapshot) =>
                  AsyncSnapshotResponseView<Loading, Error, Success>(
                snapshot: snapshot,
                loadingWidgetBuilder: (context, stateData) =>
                    LoadingIndicator(),
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
                  error: stateData.error,
                  onTryAgainTap: () => _bloc.onTryAgain.add(null),
                ),
              ),
            )),
      );

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
