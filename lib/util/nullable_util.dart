extension NullSafeFuture<T> on Future<T?> {

  Future<T> asNonNullable() => this.then((value) => value!);
}