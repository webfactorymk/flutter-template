typedef O ValueToPass<O>();

/// Error handling helper
///
/// Use [Either] to wrap your return type when there is a chance to receive [Exception]
/// instead of the expected value
abstract class Either<E extends Exception, O> {
  Either(this.isSuccess);

  final bool isSuccess;

  factory Either.success(O value) {
    return Success<E, O>(value);
  }

  factory Either.error(E e) {
    return Error<E, O>(e);
  }

  factory Either.build(ValueToPass<O> func) {
    try {
      return Success<E, O>(func());
    } on E catch (e) {
      return Error<E, O>(e);
    }
  }

  void expose(Function(E error) onError, Function(O success) onSuccess);
}

/// Success contains the value expected
class Success<E extends Exception, O> extends Either<E, O> {
  final O value;

  Success(this.value) : super(true);

  @override
  expose(Function(E error) onError, Function(O success) onSuccess) {
    onSuccess(value);
  }
}

/// Error contains the thrown [Exception]
class Error<E extends Exception, O> extends Either<E, O> {
  final E error;

  Error(this.error) : super(false);

  @override
  expose(Function(E error) onError, Function(O success) onSuccess) {
    onError(error);
  }
}
