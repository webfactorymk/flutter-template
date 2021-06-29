import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_template/data/data_not_found_exception.dart';
import 'package:flutter_template/data/repository/tasks/tasks_repository.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/feature/home/create_task/bloc/create_task_cubit.dart';
import 'package:flutter_template/feature/home/create_task/ui/create_task_view.dart';
import 'package:flutter_template/feature/home/router/home_router_delegate.dart';
import 'package:flutter_template/feature/home/task_list/bloc/task_list_bloc.dart';
import 'package:flutter_template/log/log.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/model/task/task_status.dart';
import 'package:flutter_template/resources/colors/color_palette.dart';
import 'package:flutter_template/resources/styles/text_styles.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class TaskListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          title: Text(AppLocalizations.of(context)!.task_list_title),
        ),
        body: _getBodyForState(context, state),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: ColorPalette.primaryL),
                child: Text('Drawer Header', style: kWhiteTextStyle),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.settings),
                onTap: () async {
                  Navigator.of(context).pop();
                  context
                      .read<HomeRouterDelegate>()
                      .setIsSettingsShownState(true);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.logout),
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
            _openCreateTask(context);
          },
          tooltip: AppLocalizations.of(context)!.task_list_create_new,
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }

  Widget _getBodyForState(BuildContext context, TaskListState state) {
    if (state is TasksLoadInProgress) {
      return _loadingWidget();
    } else if (state is TasksLoadSuccess) {
      final Map<TaskGroup, List<Task>> tasksGrouped = state.tasksGrouped;
      if (tasksGrouped.isEmpty) {
        return _emptyListWidget(context);
      } else {
        return Column(
          children: <Widget>[
            Expanded(
              child: _taskListWidget(
                context,
                tasksGrouped,
              ),
            ),
          ],
        );
      }
    } else if (state is TaskOpFailure) {
      return _getBodyForState(context, state.prevState);
    } else if (state is TasksLoadFailure) {
      return _errorWidget(state, context);
    } else {
      Log.e(UnimplementedError('TaskListState not consumed: $state'));
      return _errorWidget(state, context);
    }
  }

  Widget _taskListWidget(
      BuildContext context, Map<TaskGroup, List<Task>> tasksGrouped) {
    return Scrollbar(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? ColorPalette.primaryLightD
              : ColorPalette.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (TaskGroup key in tasksGrouped.keys)
                getItem(key, tasksGrouped[key]!, context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _emptyListWidget(BuildContext context) {
    return Center(
        child: Text(AppLocalizations.of(context)!.task_list_no_tasks_message));
  }

  Widget _errorWidget(var state, BuildContext context) {
    String message;
    if (state is TasksLoadFailure && state.error is DataNotFoundException) {
      message = AppLocalizations.of(context)!.task_list_error_loading_tasks;
    } else {
      message = AppLocalizations.of(context)!.task_list_error_general;
    }
    return Center(child: Text(message));
  }

  void _openCreateTask(BuildContext context) {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) {
          return BlocProvider<CreateTaskCubit>(
            create: (BuildContext context) =>
                CreateTaskCubit(serviceLocator.get<TasksRepository>()),
            child: CreateTaskView(),
          );
        });
  }

  ReorderableListView getItem(
      TaskGroup key, List<Task> tasks, BuildContext context) {
    final taskListBloc = BlocProvider.of<TaskListBloc>(context);

    return ReorderableListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        header: SizedBox(
          height: 50,
          child: Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? ColorPalette.primaryDisabledD
                : ColorPalette.backgroundGray,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                child: Text(
                  key.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        children: <Widget>[
          for (Task task in tasks)
            _TaskListItem(
              key: ValueKey(key.id + task.id),
              task: task,
              onClick: (task) => context
                  .read<HomeRouterDelegate>()
                  .setTaskDetailNavState(task),
              onStatusChange: (task, isDone) => taskListBloc
                  .add(isDone ? TaskCompleted(task) : TaskReopened(task)),
            ),
        ],
        onReorder: (oldIndex, newIndex) {
          taskListBloc.add(TasksReordered(key, oldIndex, newIndex));
        });
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
        leading: Checkbox(
            checkColor: ColorPalette.black,
            activeColor: Theme.of(context).accentColor,
            value: task.status == TaskStatus.done,
            onChanged: (newState) => onStatusChange(task, newState!)),
        trailing: Icon(Icons.reorder),
        title: task.status == TaskStatus.done
            ? Text(task.title,
                style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: ColorPalette.textGray))
            : Text(task.title),
        onTap: () => onClick(task),
      ),
    );
  }
}
