typedef O ValueToPass<O>();

/// Error handling helper
///
/// Use [Either] to wrap your return type when there is a chance to receive [Exception]
/// instead of the expected value
class Either<E extends Exception, O> {
  Either();

  factory Either.success(O value) {
    return Success<E, O>(value);
  }

  factory Either.error(Exception e) {
    return Error<E, O>(e);
  }

  factory Either.build(ValueToPass<O> func) {
    try {
      return Success<E, O>(func());
    } on Exception catch (e) {
      return Error<E, O>(e);
    }
  }
}

/// Success contains the value expected
class Success<E extends Exception, O> extends Either<E, O> {
  final O value;

  Success(this.value) : super();
}

/// Error contains the thrown [Exception]
class Error<E extends Exception, O> extends Either<E, O> {
  final Exception error;

  Error(this.error) : super();
}
