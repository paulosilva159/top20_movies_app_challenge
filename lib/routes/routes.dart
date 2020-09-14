import 'package:tokenlab_challenge/ui/components/movies_structure_type.dart';

abstract class Routes {
  static const home = 'home';
  static const initial = '/';
  static const favorites = 'favorites';
  static const movieDetails = 'movies';
  static const movieDetailsIdParam = 'id';

  static String movieById(int id) => '$movieDetails/$id';
  static String moviesListByStructure(MovieStructureType movieStructureType) =>
      '$home?type=$movieStructureType';
}
