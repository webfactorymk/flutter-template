typedef O valueToPass<O>();

class Either<E extends Exception, O> {
  Either();

  factory Either.success(O value) {
    return Success<E, O>(value);
  }

  factory Either.error(Exception e) {
    return Error<E, O>(e);
  }

  factory Either.build(valueToPass<O> func) {
    try {
      return Success<E, O>(func());
    } on Exception catch (e) {
      return Error<E, O>(e);
    }
  }
}

class Success<E extends Exception, O> extends Either<E, O> {
  final O value;

  Success(this.value) : super();
}

class Error<E extends Exception, O> extends Either<E, O> {
  final Exception error;

  Error(this.error) : super();
}
