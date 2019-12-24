import 'package:flutter/material.dart';
import 'package:flutter_tutorial/entities/TodoTask.dart';
import 'package:provider/provider.dart';
import './TodosModel.dart';

class StoreProvider extends StatefulWidget {
  final Widget child;

  const StoreProvider({Key key, this.child}) : super(key: key);

  @override
  _StoreProviderState createState() => _StoreProviderState();
}

List<TodoTask> todoList = [
  TodoTask("task 1", false),
  TodoTask("task 2", true),
  TodoTask("task 3", false)
];

class _StoreProviderState extends State<StoreProvider> {
  int _count = 10;

  @override
  Widget build(BuildContext context) {
    //状态树顶部可能依赖多个model
    return MultiProvider(
      providers: [
        //TODO 这里何时使用 .value  构造函数？
        //1. 使用 .value 构造函数是否一定会产生side effect
        //2. build 一旦执行了，状态就丢失了。如何处理？
        ChangeNotifierProvider(
          create: (_) => TodosModel.init(todoList),
        ),
        Provider.value(value: _count),
      ],
      child: widget.child,
    );
  }
}
