import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tokenlab_challenge/data/sources/movies_cache_data_source.dart';

List<SingleChildWidget> independentSourceProviders = [
  Provider(
    create: (_) => Dio(),
  ),
  Provider(
    create: (_) => MoviesCacheDataSource(),
  )
];
