import 'package:flutter/material.dart';
import 'package:tokenlab_challenge/bloc/saved_item_bloc.dart';
import 'package:tokenlab_challenge/ui/components/indicators/indicators.dart';

class FavoriteIndicator extends StatefulWidget {
  const FavoriteIndicator({@required this.movieId}) : assert(movieId != null);

  final int movieId;

  @override
  _FavoriteIndicatorState createState() => _FavoriteIndicatorState();
}

class _FavoriteIndicatorState extends State<FavoriteIndicator> {
  SavedItemBloc _bloc;

  @override
  void initState() {
    _bloc = SavedItemBloc(movieId: widget.movieId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: _bloc.onNewState,
      builder: (context, snapshot) => IconButton(
            icon: snapshot.data != null
                ? Icon(
                    snapshot.data ? Icons.favorite : Icons.favorite_border,
                    color: Colors.pinkAccent,
                  )
                : LoadingIndicator(),
            onPressed: () => _bloc.onSaveMovieIdTap,
          ));
}
