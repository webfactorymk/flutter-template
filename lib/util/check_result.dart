/// Check result annotation. Used for methods with return vital result,
/// but that might not be obvious to the developer.
///
/// Example:
///     immutableObject.changeStatus(); // WRONG, the result is missed
///     final changedObject = immutableObject.changeStatus(); // CORRECT
///
/// See https://github.com/dart-lang/linter/issues/697
class CheckResult {
  const CheckResult();
}

const CheckResult checkResult = CheckResult();
