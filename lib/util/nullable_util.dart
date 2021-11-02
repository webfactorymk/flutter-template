extension NullSafeFuture<T> on Future<T?> {

  Future<T> asNonNullable() => this.then((value) => value!);
}

extension NullSafeStream<T> on Stream<T?> {

  Stream<T> ignoreNullItems() =>
      this.where((item) => item != null).map((item) => item!);
}
