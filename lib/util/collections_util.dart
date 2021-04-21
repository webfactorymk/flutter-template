extension MapOperation<K, V> on Map<K, V> {
  /// Returns the first key for the provided value.
  /// If a match can not be found `null` is returned.
  K? getByValue(V value, {K? orElse()?}) {
    for (var key in this.keys) {
      if (this[key] == value) return key;
    }
    return orElse != null ? orElse() : null;
  }
}
