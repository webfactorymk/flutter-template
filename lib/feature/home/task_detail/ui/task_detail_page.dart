import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/feature/home/task_detail/ui/task_detail_view.dart';
import 'package:flutter_template/model/task/task.dart';

class TaskDetailPage extends Page {
  final Task task;

  TaskDetailPage({required this.task});

  @override
  Route createRoute(BuildContext context) {
    return CupertinoPageRoute(
      settings: this,
      builder: (BuildContext context) => TaskDetailView(task),
    );
  }
}
