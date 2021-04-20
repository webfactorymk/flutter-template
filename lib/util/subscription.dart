/// Service subscription. Call [cancel] to unsubscribe.
class Subscription {
  void Function()? _cancel;

  Subscription({required void Function() cancel}) : _cancel = cancel;

  /// Cancels the subscription.
  ///
  /// Can be called once. Subsequent calls have no effect.
  void cancel() {
    _cancel?.call();
    _cancel = null;
  }
}
