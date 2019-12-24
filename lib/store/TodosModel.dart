import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_tutorial/entities/TodoTask.dart';

//定义一个模型
class TodosModel with ChangeNotifier {
  TodosModel.init(List<TodoTask> tasks) {
    this._tasks.addAll(tasks);
  }

  TodosModel();

  //私有化，唯一更改数据的对外接口为addTask 和removeTask
  final List<TodoTask> _tasks = [];

  //对我暴露的数据均为不可更改的数据，以防止其他的副作用对内部数据进行更改而造成数据流不可预测
  UnmodifiableListView<TodoTask> get completeTasks =>
      UnmodifiableListView(_tasks.where((task) => task.completed));

  UnmodifiableListView<TodoTask> get allTasks => UnmodifiableListView(_tasks);

  UnmodifiableListView<TodoTask> get incompleteTasks =>
      UnmodifiableListView(_tasks.where((task) => !task.completed));

  //添加一个任务
  addTask(TodoTask task) {
    //通知所有观察者
    _tasks.add(task);
    notifyListeners();
  }

  addTasks(List<TodoTask> tasks) {
    _tasks.addAll(tasks);
    notifyListeners();
  }

  removeTask(TodoTask task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
