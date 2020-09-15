import 'package:provider/single_child_widget.dart';

import 'package:tokenlab_challenge/providers/sources/dependent_source_providers.dart';
import 'package:tokenlab_challenge/providers/sources/independent_source_providers.dart';

List<SingleChildWidget> globalProviders = [
  ...independentSourceProviders,
  ...dependentSourceProviders,
];
