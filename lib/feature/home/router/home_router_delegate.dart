import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/feature/home/router/home_nav_state.dart';
import 'package:flutter_template/feature/home/task_detail/ui/task_detail_page.dart';
import 'package:flutter_template/feature/home/task_list/ui/task_list_page.dart';
import 'package:flutter_template/feature/settings/ui/settings_page.dart';
import 'package:flutter_template/model/task/task.dart';

class HomeRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey;

  HomeRouterDelegate(this.navigatorKey,
      [this.homeNavState = const HomeNavState.taskList()]);

  HomeNavState homeNavState = HomeNavState.taskList();
  bool isSettingsShownState = false;

  void setTaskDetailNavState(Task selectedTask) {
    homeNavState = HomeNavState.taskDetail(selectedTask);
    notifyListeners();
  }

  void setIsSettingsShownState(bool isShown){
    isSettingsShownState = isShown;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        pages: [
          TaskListPage(),
          if (homeNavState is TaskDetailNavState)
            TaskDetailPage(task: (homeNavState as TaskDetailNavState).task),
          if (isSettingsShownState) SettingsPage()
        ],
        onPopPage: (route, result) {
          if(isSettingsShownState) isSettingsShownState = false;
          homeNavState = HomeNavState.taskList();
          return route.didPop(result);
        });
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* no-op */
  }
}
