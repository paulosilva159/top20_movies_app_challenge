import 'package:provider/single_child_widget.dart';

import 'package:tokenlab_challenge/data/cache/provider/movie_cache_provider.dart';
import 'package:tokenlab_challenge/data/remote/provider/movie_remote_provider.dart';
import 'package:tokenlab_challenge/data/repository/provider/movie_repository_provider.dart';

List<SingleChildWidget> movieDataProvider = [
  ...movieRemoteProvider,
  movieCacheProvider,
  movieRepositoryProvider,
];
