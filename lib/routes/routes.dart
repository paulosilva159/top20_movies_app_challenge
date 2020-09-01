abstract class Routes {
  static const initial = '/';
  static const favorites = 'favorites';
  static const movieDetails = 'movies';

  static String movieById(int id) => '$movieDetails/$id';
}
