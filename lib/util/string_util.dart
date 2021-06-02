extension Prettify on String {
  /// Shortens a long string by taking the start n chars (5 is default)
  /// and the last n chars (if long enough). Useful for logging/printing.
  String shortenForPrint([int n = 5]) {
    if (this.length <= 2 * n) {
      return this;
    } else {
      return this.substring(0, n) + '...' + this.substring(this.length - n);
    }
  }
}
