import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/data_not_found_exception.dart';
import 'package:flutter_template/feature/home/router/home_router_delegate.dart';
import 'package:flutter_template/feature/home/task_list/bloc/task_list_bloc.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/model/task/task_status.dart';
import 'package:flutter_template/resources/colors/color_palette.dart';
import 'package:flutter_template/resources/strings/string_key.dart';
import 'package:flutter_template/resources/strings/strings.dart';
import 'package:flutter_template/resources/styles/text_styles.dart';
import 'package:flutter_template/resources/theme/theme_change_notifier.dart';
import 'package:provider/provider.dart';

class TaskListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final strings = Strings.of(context)!;

    return BlocConsumer<TaskListBloc, TaskListState>(
        listener: (context, state) {
      // do stuff here based on TasksCubit's state
      if (state is TaskOpFailure) {
        //todo display an error dialog here on top of the presented UI
        Log.e('TaskOpFailure: ${state.error}');
      }
    }, builder: (context, state) {
      // return widget here based on BlocA's state, this should be a pure fn
      return Scaffold(
        appBar: AppBar(
          title: Text(strings.get(StringKey.task_list_title)),
        ),
        body: _getBodyForState(context, state, strings),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: ColorPalette.primary),
                child: Text('Drawer Header', style: kWhiteTextStyle),
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () async {
                  BlocProvider.of<TaskListBloc>(context).add(Logout());
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //TODO go to create new task screen
            context.read<ThemeChangeNotifier>().toggleTheme();
          },
          tooltip: strings.get(StringKey.task_list_create_new),
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }

  Widget _getBodyForState(
      BuildContext context, TaskListState state, Strings strings) {
    if (state is TasksLoadInProgress) {
      return _loadingWidget();
    } else if (state is TasksLoadSuccess) {
      final Map<TaskGroup, List<Task>> tasksGrouped = state.tasksGrouped;
      if (tasksGrouped.isEmpty) {
        return _emptyListWidget(strings);
      } else {
        return _taskListWidget(
          context,
          tasksGrouped.keys
              .expand((taskGroup) => []
                ..add(taskGroup)
                ..addAll(tasksGrouped[taskGroup]!))
              .toList(),
        );
      }
    } else if (state is TaskOpFailure) {
      return _getBodyForState(context, state.prevState, strings);
    } else if (state is TasksLoadFailure) {
      return _errorWidget(state, strings);
    } else {
      Log.e(UnimplementedError('TaskListState not consumed: $state'));
      return _errorWidget(state, strings);
    }
  }

  Widget _taskListWidget(BuildContext context, List<dynamic> flattenedItems) {
    final taskListBloc = BlocProvider.of<TaskListBloc>(context);
    return ListView.builder(
        itemCount: flattenedItems.length,
        padding: EdgeInsets.only(bottom: 56),
        itemBuilder: (context, index) {
          var item = flattenedItems[index];
          if (item is TaskGroup) {
            return Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: ListTile(
                  title: Text(item.name,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontSize: 15))),
            );
          } else if (item is Task) {
            return _TaskListItem(
              task: item,
              onClick: (task) => context
                  .read<HomeRouterDelegate>()
                  .setTaskDetailNavState(task),
              onStatusChange: (task, isDone) => taskListBloc
                  .add(isDone ? TaskCompleted(task) : TaskReopened(task)),
            );
          } else {
            throw Exception('Unrecognised item type.');
          }
        });
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _emptyListWidget(Strings strings) {
    return Center(
        child: Text(strings.get(StringKey.task_list_no_tasks_message)));
  }

  Widget _errorWidget(var state, Strings strings) {
    String message;
    if (state is TasksLoadFailure && state.error is DataNotFoundException) {
      message = strings.get(StringKey.task_list_error_loading_tasks);
    } else {
      message = strings.get(StringKey.task_list_error_general);
    }
    return Center(child: Text(message));
  }
}

class _TaskListItem extends StatelessWidget {
  final Task task;
  final Function(Task task) onClick;
  final Function(Task task, bool isDone) onStatusChange;

  _TaskListItem({
    Key? key,
    required this.task,
    required this.onClick,
    required this.onStatusChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Ink(
      color: themeData.cardColor,
      child: ListTile(
        title: task.status == TaskStatus.done
            ? Text(task.title,
                style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: ColorPalette.textGray))
            : Text(task.title),
        trailing: Checkbox(
            value: task.status == TaskStatus.done,
            onChanged: (newState) => onStatusChange(task, newState!)),
        onTap: () => onClick(task),
      ),
    );
  }
}
