import 'package:single_item_storage/storage.dart';

/// Const implementation that won't store any items.
/// Useful for default/null values.
class StubStorage<E> implements Storage<E> {

  const StubStorage();

  @override
  Future<void> delete() async {}

  @override
  Future<E?> get() async => null;

  @override
  Future<E> save(E item) async => item;
}
