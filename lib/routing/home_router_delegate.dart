import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/feature/home/task/bloc/tasks.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/routing/pages/loading_page.dart';

import 'app_route_path.dart';
import 'home_state.dart';
import '../feature/home/task/ui/task_details_screen.dart';
import '../feature/home/task/ui/task_list_screen.dart';

class HomeRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final HomeState homeState;

  HomeRouterDelegate(this.homeState);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(builder: (context, state) {
      if (state is TasksLoadSuccess) {
        homeState.tasks = state.tasks;
      }
      return Navigator(
        key: navigatorKey,
        pages: [
          if (homeState.selectedIndex == 0) ...[
            MaterialPage(
              child: TaskListScreen(
                tasks: homeState.tasks,
                onTapped: _handleTaskTapped,
              ),
              key: ValueKey('TaskListPage'),
            ),
            if (homeState.selectedTask != null)
              MaterialPage(
                key: ValueKey(homeState.selectedTask),
                child: TaskDetailScreen(task: homeState.selectedTask!),
              ),
          ] else
            LoadingPage()
        ],
        onPopPage: (route, result) {
          homeState.selectedTask = null;
          notifyListeners();
          return route.didPop(result);
        },
      );
    });
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath path) async {
    // This is not required for inner router delegate because it does not
    // parse route
    assert(false);
  }

  void _handleTaskTapped(Task task) {
    homeState.selectedTask = task;
    notifyListeners();
  }
}
