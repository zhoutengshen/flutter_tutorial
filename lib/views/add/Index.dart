import 'package:flutter/material.dart';
import 'package:flutter_tutorial/entities/TodoTask.dart';
import 'package:flutter_tutorial/store/TodosModel.dart';
import 'package:provider/provider.dart';

class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isSelectd = false;
    String inputText = "";
    return MaterialApp(
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '任务名称',
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                      onChanged: (str) {
                        inputText = str;
                      },
                    ),
                  ),
                  Builder(
                    builder: (ctx) {
                      return Switch(
                        value: isSelectd,
                        onChanged: (r) {
                          (ctx as Element).markNeedsBuild();
                          isSelectd = !isSelectd;
                        },
                      );
                    },
                  )
                ],
              ),
              RaisedButton(
                child: Text("添加"),
                color: Colors.blueAccent,
                onPressed: () {
                  TodoTask task = TodoTask(inputText, isSelectd);
                  Provider.of<TodosModel>(context).addTask(task);
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
