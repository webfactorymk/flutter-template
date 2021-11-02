import 'dart:async';

import 'package:flutter_template/util/nullable_util.dart';

/// Gather input changes emitted by the user and emit the latest value after a
/// time period rather than overflowing the consumer with each input change.
///
/// <br />
/// Useful when implementing input controls that need to make network calls
/// like: search as you type, toggle for item quantity in cart, etc.
///
/// <br />
/// Usage: Report every input change by calling [reportInputChange] and listen
/// to the latest distinct reported value after a [coolDown] time with
/// [consumePeriodicInputChanges]. Each subsequent input change resets the
/// previous cool down timer. When done call [close].
///
/// Example: Input of: a, app, ... appl, apple will emit app and apple
class InputBuffer<T> {
  /// Time between each reported input change. Triggered by change in input.
  final Duration coolDown;

  final StreamController<T?> _streamController = StreamController();

  Timer? _latestStateTimer;

  /// Creates a new buffer instance for a single input control.
  InputBuffer({this.coolDown = const Duration(seconds: 1)});

  /// Report each input change by calling this method. After a [coolDown] time
  /// has passed, if no additional reports are made the value will be emitted
  /// to the [consumePeriodicInputChanges] stream.
  void reportInputChange(T input) {
    _latestStateTimer?.cancel();
    _latestStateTimer = Timer(coolDown, () => _streamController.add(input));
  }

  /// Listen to the latest distinct reported value after a [coolDown] time.
  /// Each subsequent input change reported with [reportInputChange] resets
  /// the previous cool down timer. _Note: This is not a broadcast stream._
  Stream<T> consumePeriodicInputChanges() =>
      _streamController.stream.ignoreNullItems().distinct();

  /// Teardown this input buffer.
  void close() => _streamController.close();
}
