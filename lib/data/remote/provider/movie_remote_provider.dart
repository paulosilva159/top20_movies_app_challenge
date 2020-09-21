import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:tokenlab_challenge/data/remote/data_source/movies_remote_data_source.dart';

List<SingleChildWidget> movieRemoteProvider = [
  Provider(
    create: (context) => Dio(),
  ),
  ProxyProvider<Dio, MoviesRemoteDataSource>(
    update: (context, dio, moviesRemoteDataSource) =>
        MoviesRemoteDataSource(dio: dio),
  ),
];
