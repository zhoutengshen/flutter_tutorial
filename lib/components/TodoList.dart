import 'package:flutter/material.dart';
import 'package:flutter_tutorial/entities/TodoTask.dart';
import 'package:flutter_tutorial/store/TodosModel.dart';
import 'package:provider/provider.dart';

class _TodoItem extends StatelessWidget {
  final TodoTask task;

  const _TodoItem({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      trailing: IconButton(
        onPressed: () => Provider.of<TodosModel>(context).removeTask(task),
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }
}

class TodoListWrapper extends StatelessWidget {
  final Widget child;

  const TodoListWrapper({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: MediaQuery.of(context).size.height / 3,
      child: child,
    );
  }
}

class TodoList extends StatelessWidget {
  final List<TodoTask> tasks;

  const TodoList({Key key, this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TodoListWrapper(
      child: ListView(
        children: tasks
            .map(
              (task) => _TodoItem(
                task: task,
              ),
            )
            .toList(),
      ),
    );
  }
}
