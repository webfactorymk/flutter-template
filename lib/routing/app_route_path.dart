// Routes
abstract class AppRoutePath {}

class LoginPath extends AppRoutePath {}

class TaskListPath extends AppRoutePath {}

class TaskDetailsPath extends AppRoutePath {
  final int id;

  TaskDetailsPath(this.id);
}
