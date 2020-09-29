import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tokenlab_challenge/data/cache/model/movies_cache_model.dart';
import 'package:tokenlab_challenge/generated/l10n.dart';
import 'package:tokenlab_challenge/global_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive
    ..init((await getApplicationDocumentsDirectory()).path)
    ..registerAdapter<MovieLongDetailsCM>(MovieLongDetailsCMAdapter())
    ..registerAdapter<MovieShortDetailsCM>(MovieShortDetailsCMAdapter());

  runApp(
    TMGlobalProvider(
      builder: (context) => App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: ThemeData(
            textTheme: const TextTheme(
              headline1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          onGenerateRoute: Provider.of<RouteFactory>(context, listen: false));
}
