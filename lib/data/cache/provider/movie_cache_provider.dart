import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:tokenlab_challenge/data/cache/data_source/movies_cache_data_source.dart';

SingleChildWidget movieCacheProvider = Provider(
  create: (context) => MoviesCacheDataSource(),
);
