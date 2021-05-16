import 'package:flutter_template/util/collections_util.dart';
import 'package:json_annotation/json_annotation.dart';

const DONE = TaskStatus.done;
const NOT_DONE = TaskStatus.notDone;

/// Current status of a [Task].
enum TaskStatus {
  @JsonValue(0) notDone,
  @JsonValue(1) done,
}

const _apiKeyLookupMap = {
  0: TaskStatus.notDone,
  1: TaskStatus.done,
};

/// Extension functions for converting the enum value to its key
/// and the reverse op - doing lookup from key.
extension TaskStatusLookup on TaskStatus {
  static TaskStatus? fromApiKey(int key, {TaskStatus? defaultValue}) =>
      _apiKeyLookupMap[key] ?? defaultValue;

  int toApiKey() => _apiKeyLookupMap.getByValue(this)!;
}
