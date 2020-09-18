class PathBuilder {
  static const _baseUrl = 'https://desafio-mobile.nyc3.digitaloceanspaces.com/';
  static const _moviesResource = 'movies';

  static String movieList() => '$_baseUrl$_moviesResource';

  static String movie(int id) => '$_baseUrl$_moviesResource/$id';
}
