import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_group.dart';
import 'package:flutter_template/model/task/task_status.dart';

const List<TaskGroup> DUMMY_TASK_GROUPS = [
  TaskGroup('tg-1', 'Home', ['t1', 't2', 't3', 't4']),
  TaskGroup('tg-2', 'Work', ['t5', 't6', 't7']),
  TaskGroup('tg-3', 'Other', ['t8', 't9', 't10'])
];

const List<Task> DUMMY_TASKS = [
  Task(id: 't1', title: 'Clean kitchen', status: DONE),
  Task(id: 't2', title: 'Plant flower', description: 'Any', status: NOT_DONE),
  Task(id: 't3', title: 'Buy milk', status: NOT_DONE),
  Task(id: 't4', title: 'Fix cupboard door', status: NOT_DONE),
  Task(id: 't5', title: 'Pretend to work', status: DONE),
  Task(id: 't6', title: 'Vacation', description: '2 weeks', status: DONE),
  Task(id: 't7', title: 'Pretend to work again', status: NOT_DONE),
  Task(id: 't8', title: 'Refuel car', status: DONE),
  Task(id: 't9', title: 'Visit dentist', status: NOT_DONE),
  Task(id: 't10', title: 'Pickup mail', status: DONE)
];
