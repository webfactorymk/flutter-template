import 'package:flutter/material.dart';
import 'package:flutter_template/model/task/task.dart';

class HomeState extends ChangeNotifier {
  List<Task> tasks;
  int _selectedIndex;
  Task? _selectedTask;

  HomeState()
      : _selectedIndex = 0,
        tasks = [];

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int idx) {
    _selectedIndex = idx;
    notifyListeners();
  }

  Task? get selectedTask => _selectedTask;

  set selectedTask(Task? task) {
    _selectedTask = task;
    notifyListeners();
  }

  int getSelectedBookById() {
    if (_selectedTask == null || !tasks.contains(_selectedTask)) return 0;
    return tasks.indexOf(_selectedTask!);
  }

  void setSelectedBookById(int id) {
    if (id < 0 || id > tasks.length - 1) {
      return;
    }

    _selectedTask = tasks[id];
    notifyListeners();
  }
}
