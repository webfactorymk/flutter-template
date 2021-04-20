extension MapOperation<K, V> on Map<K, V> {
  K? getByValue(V value, {K orElse()?}) =>
      this.keys.firstWhere((key) => this[key] == value,
          orElse: orElse ?? () => null as K,);
}
