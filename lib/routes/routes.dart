import 'package:tokenlab_challenge/ui/components/movies_structure_type.dart';

abstract class Routes {
  static const moviesList = 'movies';
  static const home = '/';
  static const favorites = 'favorites';
  static const movieDetails = 'details';
  static const movieDetailsIdParam = 'id';

  static const String moviesListQueryParam = 'type';

  static String movieById(int id) => '$movieDetails/$id';
  static String moviesListByStructure(MovieStructureType movieStructureType) =>
      '$moviesList?type=$movieStructureType';
}
