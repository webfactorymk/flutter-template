import 'package:flutter_template/data/repository/tasks/tasks_cache_data_source.dart';

import 'tasks_data_source_base_test.dart';

void main() {
  executeTasksDataSourceBaseTests(() => new TasksCacheDataSource('userId'));
}