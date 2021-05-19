import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/feature/home/task/bloc/tasks.dart';
import 'package:flutter_template/feature/home/task/ui/task_details_screen.dart';
import 'package:flutter_template/feature/home/task/ui/task_list_screen.dart';
import 'package:flutter_template/routing/pages/loading_page.dart';
import 'package:provider/provider.dart';


import 'app_route_path.dart';
import 'home_state.dart';

class HomeRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final HomeState homeState;

  HomeRouterDelegate(this.homeState);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeState>(builder: (context, state, child) {
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
    });
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath path) async {
    // This is not required for inner router delegate because it does not
    // parse route
    assert(false);
  }
}
