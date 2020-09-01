abstract class Routes {
  static const initial = '/';
  static const favorites = 'favorites';
  static const movieDetails = 'movies';

  static const movieStructureTypeParam = 'movieStructureType';
  static const movieDetailsIdParam = 'id';

  static String movieById(int id) => '$movieDetails/$id';
}
