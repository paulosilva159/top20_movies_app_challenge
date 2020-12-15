import 'package:flutter/widgets.dart';

class AsyncSnapshotResponseView<Loading, Error, Success>
    extends StatelessWidget {
  AsyncSnapshotResponseView({
    @required this.loadingWidgetBuilder,
    @required this.errorWidgetBuilder,
    @required this.successWidgetBuilder,
    @required this.snapshot,
    Key key,
  })  : assert(loadingWidgetBuilder != null),
        assert(errorWidgetBuilder != null),
        assert(successWidgetBuilder != null),
        assert(snapshot != null),
        assert(Loading != dynamic),
        assert(Error != dynamic),
        assert(Success != dynamic),
        super(key: key);

  final AsyncSnapshot snapshot;
  final Widget Function(BuildContext context, Success success)
      successWidgetBuilder;
  final Widget Function(BuildContext context, Error error) errorWidgetBuilder;
  final Widget Function(BuildContext context, Loading loading)
      loadingWidgetBuilder;

  @override
  Widget build(BuildContext context) {
    final snapshotData = snapshot.data;

    if (snapshotData == null || snapshotData is Loading) {
      return loadingWidgetBuilder(
        context,
        snapshotData,
      );
    } else if (snapshotData is Error) {
      return errorWidgetBuilder(
        context,
        snapshotData,
      );
    } else if (snapshotData is Success) {
      return successWidgetBuilder(
        context,
        snapshotData,
      );
    }

    throw UnknownStateTypeException();
  }
}

class UnknownStateTypeException implements Exception {}
