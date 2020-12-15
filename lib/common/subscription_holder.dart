import 'package:rxdart/rxdart.dart';

mixin SubscriptionHolder {
  final CompositeSubscription subscriptions = CompositeSubscription();

  void disposeAll() {
    subscriptions.clear();
  }
}
