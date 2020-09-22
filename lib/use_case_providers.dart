import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:domain/use_case/favorite_movie_uc.dart';
import 'package:domain/use_case/get_movie_details_uc.dart';
import 'package:domain/use_case/unfavorite_movie_uc.dart';
import 'package:domain/data_repository/movie_data_repository.dart';
import 'package:domain/use_case/get_movies_list_uc.dart';

import 'package:tokenlab_challenge/common/utils.dart';

List<SingleChildWidget> useCaseProviders = [
  ProxyProvider2<MovieDataRepository, Log, GetMoviesListUC>(
    update: (context, repository, log, _) =>
        GetMoviesListUC(repository: repository, logger: log.errorLogger),
  ),
  ProxyProvider2<MovieDataRepository, Log, GetMovieDetailsUC>(
    update: (context, repository, log, _) =>
        GetMovieDetailsUC(repository: repository, logger: log.errorLogger),
  ),
  ProxyProvider2<MovieDataRepository, Log, FavoriteMovieUC>(
    update: (context, repository, log, _) =>
        FavoriteMovieUC(repository: repository, logger: log.errorLogger),
  ),
  ProxyProvider2<MovieDataRepository, Log, UnfavoriteMovieUC>(
    update: (context, repository, log, _) =>
        UnfavoriteMovieUC(repository: repository, logger: log.errorLogger),
  ),
];

SingleChildWidget logProvider = Provider<Log>(
  create: (context) => Log(),
);
