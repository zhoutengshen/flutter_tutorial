import 'package:flutter/material.dart';
import 'package:flutter_tutorial/components/TodoList.dart';
import 'package:flutter_tutorial/store/TodosModel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  _buildAddWidget(ctx) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(ctx).pushNamed("/add");
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Consumer<TodosModel>(
            builder: (_, tm, child) => TodoList(
              tasks: tm.allTasks.toList(),
            ),
          ),
          Consumer<TodosModel>(
            builder: (_, tm, child) => TodoList(
              tasks: tm.completeTasks.toList(),
            ),
          ),
          Consumer<TodosModel>(
            builder: (_, tm, child) => TodoList(
              tasks: tm.incompleteTasks.toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildAddWidget(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
