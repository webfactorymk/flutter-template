import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/feature/home/router/home_nav_state.dart';
import 'package:flutter_template/feature/home/task_detail/ui/task_detail_page.dart';
import 'package:flutter_template/feature/home/task_list/ui/task_list_page.dart';
import 'package:flutter_template/model/task/task.dart';

class HomeRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  HomeNavState homeNavState;

  HomeRouterDelegate([this.homeNavState = const HomeNavState.taskList()]);

  void setTaskDetailNavState(Task selectedTask) {
    homeNavState = HomeNavState.taskDetail(selectedTask);
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        pages: [
          TaskListPage(),
          if (homeNavState is TaskDetailNavState)
            TaskDetailPage(task: (homeNavState as TaskDetailNavState).task)
        ],
        onPopPage: (route, result) {
          homeNavState = HomeNavState.taskList();
          return route.didPop(result);
        });
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* no-op */
  }
}
