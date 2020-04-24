import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Entry.dart';

void main() => runApp(MyEntry(
      widget: TimerTestWidget(),
    ));

class TimerTestWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TimerTestState();
  }
}

class TimerTestState extends State<TimerTestWidget> {
  HeightSpeedModelDevicesTimer heightSpeedModelDevicesTimer =
      HeightSpeedModelDevicesTimer();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text("SELECT DEVICE"),
            onPressed: () {
              heightSpeedModelDevicesTimer.selectedDeviceByNo("1213");
            },
          ),
          RaisedButton(
            child: Text("ADD DEVICE"),
            onPressed: () {
              DeviceTimeStruct ds = DeviceTimeStruct(
                  "1213", DateTime.now().millisecondsSinceEpoch.toString());
              heightSpeedModelDevicesTimer.addDevice(ds);
            },
          ),
          HeightSpeedModelDevicesTimerWidget(heightSpeedModelDevicesTimer)
        ],
      ),
    );
  }
}

class DeviceTimeStruct {
  /// 唯一设备号
  final String deviceNo;

  /// 开启告诉模式的时间戳
  final String startTimestamp;

  DeviceTimeStruct(this.deviceNo, this.startTimestamp)
      : assert(deviceNo != null && startTimestamp != null);

  @override
  String toString() {
    return "{deviceNo:$deviceNo,startTimestamp:$startTimestamp}";
  }

  @override
  bool operator ==(other) {
    return deviceNo == other.deviceNo;
  }
}

typedef HeightSpeedModelDevicesTimerCallback = void Function(
    DeviceTimeStruct devices);

/// 设备（多个）高速模式计时器
class HeightSpeedModelDevicesTimer {
  List<DeviceTimeStruct> _devices = <DeviceTimeStruct>[];
  String deviceNo;
  static const duration = const Duration(seconds: 1);

  // 计时器回调函数
  List<HeightSpeedModelDevicesTimerCallback> callbacks = [];

  Timer _timer;

  HeightSpeedModelDevicesTimer({this.deviceNo, timerCallBack}) {
    if (timerCallBack != null) callbacks.add(timerCallBack);
  }

  /// 计时器开始计时
  start() {
    print('start');
    _timer = Timer.periodic(duration, (Timer timer) {
      callbackAll();
    });
  }

  /// 添加注册的回调
  addCallback(HeightSpeedModelDevicesTimerCallback callback) {
    if (callback != null) callbacks.add(callback);
  }

  /// 移除注册的回调
  removeCallback(callback) {
    callbacks.remove(callback);
  }

  ///回调所有的回调
  callbackAll() {
    DeviceTimeStruct selectedDeviceTimeStruct = _devices
        .firstWhere((item) => item.deviceNo == deviceNo, orElse: () => null);
    if (selectedDeviceTimeStruct != null) {
      print('>');
      callbacks.forEach((f) => f(selectedDeviceTimeStruct));
    }
  }

  /// 选择某个设备同时触发回调
  selectedDeviceByNo(devicesNo) {
    this.deviceNo = devicesNo;
    callbackAll();
  }

  /// 添加设备，同时触发回调
  addDevice(DeviceTimeStruct newDevice, {isAddAll = false}) {
    DeviceTimeStruct d = _devices.firstWhere((device) => newDevice == device,
        orElse: () => null);
    // 如果存在，那么更新
    if (d != null) {
      _devices.remove(d);
    }
    _devices.add(newDevice);
    if (!isAddAll) {
      callbackAll();
    }
  }

  addAllDevice(List<DeviceTimeStruct> newDevices) {
    newDevices.forEach((item) => addDevice(item));
    callbackAll();
  }

  /// 销毁计时器
  destroy() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }
}

class HeightSpeedModelDevicesTimerWidget extends StatefulWidget {
  final HeightSpeedModelDevicesTimer timer;

  const HeightSpeedModelDevicesTimerWidget(this.timer, {Key key})
      : assert(timer != null);

  @override
  State<StatefulWidget> createState() {
    return HeightSpeedModelDevicesTimerState();
  }
}

class HeightSpeedModelDevicesTimerState
    extends State<HeightSpeedModelDevicesTimerWidget> {
  DeviceTimeStruct selectedDeviceTimeStruct;

  @override
  void initState() {
    super.initState();
    widget.timer.start();
    widget.timer.addCallback(_timerCallback);
  }

  /// 回调发生时机一共有三种
  /// 1.正常timer回调
  /// 2.添加设备发送回调
  /// 3.设备选择发送变化时发生回调
  _timerCallback(DeviceTimeStruct deviceTimeStruct) {
    setState(() {
      selectedDeviceTimeStruct = deviceTimeStruct;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("ASD>");
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    String startTimestampStr = selectedDeviceTimeStruct == null
        ? ""
        : selectedDeviceTimeStruct.startTimestamp;
    int startTime = int.parse(startTimestampStr, onError: (s) => currentTime);
    // TODO: implement build
    return RepaintBoundary(
      child: selectedDeviceTimeStruct == null
          ? Container()
          : Text((currentTime - startTime).toString()),
    );
  }

  dispose() {
    widget.timer.destroy();
  }
}
