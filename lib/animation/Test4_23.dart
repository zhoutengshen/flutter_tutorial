import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Entry.dart';

void main() => runApp(MyEntry(
      widget: PositionTest(),
    ));

class PositionTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: StackTest(),
      ),
    );
  }
}

class StackTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        Positioned(
          left: 30,
          top: 30,
          child: RaisedButton(
            child: Text("TOP"),
            onPressed: () {
              print("TOP");
            },
          ),
        ),
        Positioned(
          right: 30,
          top: 30,
          child: RaisedButton(
            child: Text("LEFT"),
          ),
        ),
        Positioned(
          left: 30,
          bottom: 30,
          child: RaisedButton(
            child: Text("bottom"),
          ),
        ),
        PositionTestStateWidget(),
      ],
    );
  }
}

class PositionTestStateWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PositionTestState();
  }
}

class PositionTestState extends State<PositionTestStateWidget>
    with SingleTickerProviderStateMixin {
  List<IconData> myIcons = <IconData>[
    Icons.map,
    Icons.print,
    Icons.account_circle,
    Icons.camera,
    Icons.zoom_out_map,
    Icons.camera_alt,
  ];
  Animation<double> animation;
  AnimationController controller;

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    //图片宽高从0变到300
    animation = new Tween(begin: 0.0, end: 30.0).animate(controller)
      ..addListener(() {
        setState(() => {});
      })
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          setState(() => this.fullScreen = true);
        } else if (s == AnimationStatus.reverse) {
          setState(() => this.fullScreen = false);
        }
      });
    //启动动画(正向执行)
  }

  bool fullScreen = false;

  add() {
    controller.forward();
    if (controller.value >= 1) {
      controller.reverse();
    }
  }

  _buildIcons() {
    return Column(
      children: []
        ..addAll(myIcons
            .map(
              (icon) => Container(
                child: ClipRRect(
                  child: IconButton(
                    icon: Icon(icon),
                    onPressed: (){
                      controller.reverse();
                    },
                  ),
                ),
                height: animation.value,
                width: animation.value,
              ),
            )
            .toList())
        ..add(GestureDetector(
          onTap: add,
          child: Container(
            height: 30,
            width: 30,
            child: Icon(Icons.add),
          ),
        )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent, // 必须加这个  否则点击空白处会没有反应
            child: Container(
//              decoration: BoxDecoration(color: Colors.red),
              width: fullScreen ? 1000 : 0,
              height: fullScreen ? 1000 : 0,
            ),
            onTap: () => controller.reverse(),
          ),
        ),
        Positioned(
          right: 100,
          bottom: 300,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(10)),
            child: _buildIcons(),
          ),
        ),
      ],
    );
  }

  dispose() {
    //路由销毁时需要释放动画资源
    controller.dispose();
    super.dispose();
  }
}
