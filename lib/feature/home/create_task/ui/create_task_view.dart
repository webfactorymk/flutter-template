import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/feature/home/create_task/bloc/create_task_cubit.dart';
import 'package:flutter_template/feature/home/create_task/bloc/create_task_state.dart';
import 'package:flutter_template/model/task/task.dart';
import 'package:flutter_template/model/task/task_status.dart';

class CreateTaskView extends StatefulWidget {
  @override
  _CreateTaskViewState createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Task'),
          centerTitle: true,
          leading: Container(),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        ),
        body: BlocConsumer<CreateTaskCubit, CreateTaskState>(
            listener: (listenerContext, state) {
          if (state is CreateTaskSuccess) {
            Navigator.of(context).pop();
          }
        }, builder: (context, state) {
          if (state is CreateTaskInProgress) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _taskNameController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a task name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _taskDescriptionController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Description",
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    child: Text('Create'),
                    onPressed: () => _onCreatePressed(context),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  _onCreatePressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<CreateTaskCubit>(context).onCreateTask(Task(
        id: 'id',
        title: _taskNameController.text,
        description: _taskDescriptionController.text,
        status: TaskStatus.notDone,
      ));
    }
  }
}
