import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tokenlab_challenge/common/subscription_holder.dart';

class ActionStreamListener<T> extends StatefulWidget {
  const ActionStreamListener({
    @required this.child,
    @required this.actionStream,
    @required this.onReceived,
    Key key,
  })  : assert(child != null),
        assert(actionStream != null),
        assert(onReceived != null),
        super(key: key);

  final Widget child;
  final Stream<T> actionStream;
  final Function(T action) onReceived;

  @override
  _ActionStreamListenerState<T> createState() =>
      _ActionStreamListenerState<T>();
}

class _ActionStreamListenerState<T> extends State<ActionStreamListener<T>>
    with SubscriptionHolder {
  @override
  void initState() {
    widget.actionStream
        .listen(
          widget.onReceived,
        )
        .addTo(subscriptions);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    disposeAll();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
