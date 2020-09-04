import 'dart:io';

import 'package:flutter/material.dart';

import 'package:tokenlab_challenge/generated/l10n.dart';

import '../../components/movies_structure.dart';
import 'movies_list_screen_state.dart';

// class MoviesListBody extends StatelessWidget {
//   const MoviesListBody({
//     @required this.moviesListScreenState,
//     @required this.movieStructureType,
//     @required this.onTryAgainTap,
//   })  : assert(moviesListScreenState != null),
//         assert(movieStructureType != null),
//         assert(onTryAgainTap != null);
//
//   final AsyncSnapshot moviesListScreenState;
//   final MovieStructureType movieStructureType;
//   final VoidCallback onTryAgainTap;
//
//   @override
//   Widget build(BuildContext context) {
//     if (moviesListScreenState.data is Loading) {
//       return const SliverFillRemaining(
//         child: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     } else if (moviesListScreenState.data is Error) {
//       return SliverFillRemaining(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(
//               height: 10,
//             ),
//             if (moviesListScreenState.data.error is SocketException)
//               const Text(
//                 'S.of(context).connectionErrorMessage',
//                 style: TextStyle(
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12),
//               )
//             else
//               const Text(
//                 'S.of(context).genericErrorMessage',
//                 style: TextStyle(
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12),
//               ),
//             RaisedButton(
//               onPressed: onTryAgainTap,
//               child: const Text('S.of(context).tryAgainMessage,'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       return MoviesStructure(
//         moviesList: moviesListScreenState.data.movieList,
//         movieStructureType: movieStructureType,
//       );
//     }
//   }
// }

class MoviesListBody extends StatelessWidget {
  const MoviesListBody({
    @required this.moviesListScreenState,
    @required this.movieStructureType,
    @required this.onTryAgainTap,
  })  : assert(moviesListScreenState != null),
        assert(movieStructureType != null),
        assert(onTryAgainTap != null);

  final AsyncSnapshot moviesListScreenState;
  final MovieStructureType movieStructureType;
  final VoidCallback onTryAgainTap;

  @override
  Widget build(BuildContext context) {
    print('1');
    print(moviesListScreenState.data);
    if (moviesListScreenState.data == null ||
        moviesListScreenState.data is Loading) {
      print('2');
      print(moviesListScreenState.data);
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (moviesListScreenState.data is Error) {
      print('3');
      print(moviesListScreenState.data);
      return SliverFillRemaining(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            if (moviesListScreenState.data.error is SocketException)
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
              onPressed: onTryAgainTap,
              child: Text(
                S.of(context).tryAgainMessage,
              ),
            ),
          ],
        ),
      );
    } else if (moviesListScreenState.data is Success) {
      print('4');
      print(moviesListScreenState.data);

      return MoviesStructure(
        moviesList: moviesListScreenState.data.movieList,
        movieStructureType: movieStructureType,
      );
    }

    return const SliverFillRemaining(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
