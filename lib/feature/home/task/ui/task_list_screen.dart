import 'package:flutter/material.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/routing/home_state.dart';
import 'package:flutter_template/user/user_manager.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatelessWidget {
  final List<Task> tasks;

  TaskListScreen({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            height: 200,
            child: ListView(
              children: [
                for (var task in tasks)
                  ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.id),
                    onTap: () => _onTapped(context, task),
                  )
              ],
            ),
          ),
          ElevatedButton(
            child: Text('Log out'),
            onPressed: () => _onLogoutPressed(context),
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.black,
              primary: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  _onLogoutPressed(BuildContext context) {
    serviceLocator.get<UserManager>().logout();
  }

  void _onTapped(BuildContext context, Task task) {
    Provider.of<HomeState>(context, listen: false).selectedTask = task;
  }
}
