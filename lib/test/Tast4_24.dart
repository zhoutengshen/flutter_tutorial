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
            child: Text("SELECT DEVICE_1"),
            onPressed: () {
              heightSpeedModelDevicesTimer.selectedDeviceByNo("DEVICE_1");
            },
          ),
          RaisedButton(
            child: Text("SELECT DEVICE_2"),
            onPressed: () {
              heightSpeedModelDevicesTimer.selectedDeviceByNo("DEVICE_2");
            },
          ),
          RaisedButton(
            child: Text("ADD DEVICE 1"),
            onPressed: () {
              DateTime startTime = DateTime.now();
              DeviceTimeStruct ds = DeviceTimeStruct(
                  "DEVICE_1", startTime, startTime.add(Duration(minutes: 1)));
              heightSpeedModelDevicesTimer.addDevice(ds);
            },
          ),
          RaisedButton(
            child: Text("ADD DEVICE 2"),
            onPressed: () {
              DateTime startTime = DateTime.now();
              DeviceTimeStruct ds = DeviceTimeStruct(
                  "DEVICE_2", startTime, startTime.add(Duration(minutes: 2)));
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
  final DateTime startDateTime;

  final DateTime endDateTime;

  DeviceTimeStruct(
    this.deviceNo,
    this.startDateTime,
    this.endDateTime,
  ) : assert(deviceNo != null && startDateTime != null);

  @override
  String toString() {
    return "{deviceNo:$deviceNo,startTimestamp:$startDateTime}";
  }
}

/// 1.正常timer回调
/// 2.添加设备发生回调
/// 3.设备选择时发生回调
/// 4. 设备到达时间发生回调，
enum CallbackStatus { NORMAL, ADD, SELECTED, COMPLETE }

typedef HeightSpeedModelDevicesTimerCallback = void
    Function(DeviceTimeStruct devices, [CallbackStatus callbackStatus]);

/// 设备（多个）高速模式计时器
class HeightSpeedModelDevicesTimer {
  List<DeviceTimeStruct> _devices = <DeviceTimeStruct>[];
  String selectedDeviceNo;
  static const duration = const Duration(seconds: 1);

  // 计时器回调函数
  List<HeightSpeedModelDevicesTimerCallback> callbacks = [];

  Timer _timer;

  HeightSpeedModelDevicesTimer({this.selectedDeviceNo, timerCallBack}) {
    if (timerCallBack != null) callbacks.add(timerCallBack);
  }

  /// 计时器开始计时
  start() {
    if (_timer == null) {
      _timer = Timer.periodic(duration, (Timer timer) {
        _callbackAll(callbackStatus: CallbackStatus.NORMAL);
      });
      print("启动计时器");
    }
  }

  /// 添加注册的回调
  addCallback(HeightSpeedModelDevicesTimerCallback callback) {
    assert(callback != null);
    callbacks.add(callback);
  }

  /// 移除注册的回调
  removeCallback(callback) {
    callbacks.remove(callback);
  }

  /// 回调所有的回调
  /// 标记已完成
  /// 清除已成为
  _callbackAll({callbackStatus}) {
    DateTime currentTime = DateTime.now();
    DeviceTimeStruct selectedDeviceTimeStruct;
    List<DeviceTimeStruct> tempList = [];
    _devices.forEach((item) {
      if (item.endDateTime.millisecondsSinceEpoch >=
          currentTime.millisecondsSinceEpoch) {
        tempList.add(item);
        if (item.deviceNo == selectedDeviceNo) {
          selectedDeviceTimeStruct = item;
        }
      } else {
        String deviceNo = item.deviceNo;
        // 设备完成回调？？？？
        print("设备$deviceNo：结束高速模式");
      }
    });
    _devices = tempList;
    callbacks.forEach((f) => f(selectedDeviceTimeStruct, callbackStatus));
    // 做些少优化
    _updateTimerStatus();
  }

  // 更新计时器状态
  _updateTimerStatus() {
    if (_timer != null && _timer.isActive && _devices.isEmpty) {
      // 如果 没有设备开启高速模式，那么关闭计时器
      print("定时器处于活跃状态，当高速设备列表为空，即将关闭");
      destroy();
    } else if ((_timer == null || !_timer.isActive) && _devices.isNotEmpty) {
      // 如果 定时器处于 关闭状态 且高速设备列表不为空，开启定时器；
      print("定时器处于非活跃状态，当高速设备列表不为空，即将开启");
      start();
    }
  }

  /// 选择某个设备同时触发回调
  selectedDeviceByNo(devicesNo) {
    this.selectedDeviceNo = devicesNo;
    _callbackAll(callbackStatus: CallbackStatus.SELECTED);
  }

  /// 添加设备，同时触发回调
  addDevice(DeviceTimeStruct newDevice, {isAddAll = false}) {
    DeviceTimeStruct d = _devices.firstWhere(
        (device) => newDevice.deviceNo == device.deviceNo,
        orElse: () => null);
    // 如果存在，那么更新
    if (d != null) {
      _devices.remove(d);
    }
    _devices.add(newDevice);
    if (!isAddAll) {
      _callbackAll(callbackStatus: CallbackStatus.ADD);
    }
  }

  addAllDevice(List<DeviceTimeStruct> newDevices) {
    newDevices.forEach((item) => addDevice(item));
    _callbackAll(callbackStatus: CallbackStatus.ADD);
  }

  /// 销毁计时器
  destroy() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
      print("销毁计时器");
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

  /// 回调发生时机一共有三种 均存在 deviceTimeStruct = null;
  /// 1.正常timer回调
  /// 2.添加设备发生回调
  /// 3.设备选择时发生回调
  void _timerCallback(DeviceTimeStruct deviceTimeStruct,
      [CallbackStatus callbackStatus]) {
    setState(() {
      selectedDeviceTimeStruct = deviceTimeStruct;
    });
  }

  @override
  Widget build(BuildContext context) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    bool showSelectedDevice = selectedDeviceTimeStruct != null;
    // TODO: implement build
    return RepaintBoundary(
      child: !showSelectedDevice
          ? Container()
          : Text((selectedDeviceTimeStruct.endDateTime.millisecondsSinceEpoch -
                  currentTime)
              .toString()),
    );
  }

  dispose() {
    widget.timer.destroy();
  }
}
