import 'package:flutter/material.dart';

import 'routes/routes.dart';

import 'ui/view/movie_details_screen/movie_details_screen.dart';
import 'ui/view/movies_list_screen/movies_list_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        initialRoute: Routes.initial,
        routes: {
          Routes.initial: (context) => MoviesListScreen(),
          Routes.details: (context) => MovieDetailsScreen()
        },
      );
}
