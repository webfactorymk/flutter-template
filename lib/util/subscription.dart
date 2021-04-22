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

/// Service subscription with async cancel. Call [cancel] to unsubscribe.
class AsyncSubscription {
  Future<void> Function()? _cancel;

  AsyncSubscription({required Future<void> Function() cancel})
      : _cancel = cancel;

  /// Cancels the subscription.
  ///
  /// Can be called once. Subsequent calls have no effect.
  Future<void> cancel() async {
    await _cancel?.call();
    _cancel = null;
  }
}
