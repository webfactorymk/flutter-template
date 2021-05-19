import 'package:flutter/material.dart';
import 'package:flutter_template/model/task/task.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Back'),
            ),
            Text(task.title, style: Theme.of(context).textTheme.headline6),
            Text(task.id,
                style: Theme.of(context).textTheme.subtitle1),
          ],
        ),
      ),
    );
  }
}
