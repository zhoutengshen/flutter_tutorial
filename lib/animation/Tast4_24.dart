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
              DeviceTimeStruct ds = DeviceTimeStruct(
                  "DEVICE_1",
                  DateTime.now().millisecondsSinceEpoch,
                  DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 5);
              heightSpeedModelDevicesTimer.addDevice(ds);
            },
          ),
          RaisedButton(
            child: Text("ADD DEVICE 2"),
            onPressed: () {
              DeviceTimeStruct ds = DeviceTimeStruct(
                  "DEVICE_2",
                  DateTime.now().millisecondsSinceEpoch,
                  DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 20);
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
  final int startTimestamp;

  final int endTimestamp;

  DeviceTimeStruct(
    this.deviceNo,
    this.startTimestamp,
    this.endTimestamp,
  ) : assert(deviceNo != null && startTimestamp != null);

  @override
  String toString() {
    return "{deviceNo:$deviceNo,startTimestamp:$startTimestamp}";
  }
}

/// 1.正常timer回调
/// 2.添加设备发生回调
/// 3.设备选择时发生回调
/// 4. 设备到达时间发生回调，
enum CallbackStatus {
  NORMAL,
  ADD,
  SELECTED,
}

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
    print('start');
    _timer = Timer.periodic(duration, (Timer timer) {
      _callbackAll(callbackStatus: CallbackStatus.NORMAL);
    });
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
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    DeviceTimeStruct selectedDeviceTimeStruct;
    List<DeviceTimeStruct> tempList = [];
    _devices.forEach((item) {
      if (item.endTimestamp >= currentTime) {
        tempList.add(item);
        if (item.deviceNo == selectedDeviceNo) {
          selectedDeviceTimeStruct = item;
        }
      }
    });
    _devices = tempList;
    callbacks.forEach((f) => f(selectedDeviceTimeStruct, callbackStatus));
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
    HeightSpeedModelDevicesTimerCallback a = _timerCallback;
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
          : Text((currentTime - selectedDeviceTimeStruct.startTimestamp)
              .toString()),
    );
  }

  dispose() {
    widget.timer.destroy();
  }
}
