typedef O valueToPass<O>();

class Either<E extends Exception, O> {
  Either();

  factory Either.build(valueToPass<O> func) {
    try {
      return Success<E, O>(func());
    } on Exception catch (e) {
      return Error<E, O>(e);
    }
  }
}

class Success<E extends Exception, O> extends Either<E, O> {
  late O value;

  Success(this.value) : super();
}

class Error<E extends Exception, O> extends Either<E, O> {
  late Exception error;

  Error(this.error) : super();
}
