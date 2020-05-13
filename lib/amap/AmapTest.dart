import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Entry.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('test'),
          onPressed: () {
            Navigator.of(context).pushNamed("/home");
          },
        ),
      ),
    );
  }
}

Future<bool> requestPermission() async {
  final permissionStatus = await Permission.location.request();
  if (permissionStatus == PermissionStatus.granted) {
    return true;
  } else {
    toast('需要定位权限!');
    return false;
  }
}

class AmapWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AmapWidgetState();
  }
}

class _AmapWidgetState extends State<AmapWidget> {
  MapType mapType = MapType.Night;
  double height = 500;
  @override
  Widget build(BuildContext context) {
    height = height == 500 ? height - 1 : height + 1;
    return Column(
      children: <Widget>[
        Container(
          height: height,
          child: AmapView(
            // 地图类型 (可选)
            mapType: mapType,
            // 是否显示缩放控件 (可选)
            showZoomControl: true,
            // 是否显示指南针控件 (可选)
            showCompass: false,
            // 是否显示比例尺控件 (可选)
            showScaleControl: true,
            // 是否使能缩放手势 (可选)
            zoomGesturesEnabled: true,
            // 是否使能滚动手势 (可选)
            scrollGesturesEnabled: true,
            // 是否使能旋转手势 (可选)
            rotateGestureEnabled: true,
            // 是否使能倾斜手势 (可选)
            tiltGestureEnabled: true,
            // 缩放级别 (可选)
            zoomLevel: 10,
            // 中心点坐标 (可选)
            centerCoordinate: LatLng(39, 116),
            // 标记 (可选)
            markers: <MarkerOption>[],
            onMapCreated: (controller) async {
//              _amapView.currentState
              if (await requestPermission()) {
//                await controller.showMyLocation(MyLocationOption(show: true));
              }
            },
          ),
        ),
        RaisedButton(
          child: Text('ok'),
          onPressed: () {
            if (mapType == MapType.Standard) {
              mapType = MapType.Night;
            } else {
              mapType = MapType.Standard;
            }
            setState(() {});
            print(mapType);
          },
        ),
        Builder(
          builder: (ctx) {
            return RaisedButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(ctx).pushNamed("/test");
              },
            );
          },
        )
      ],
    );
  }
}

var _routeConfigs = {
  "/home": (_) => Scaffold(
        body: AmapWidget(),
      ),
  "/test": (_) => Test()
};

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: _routeConfigs,
      initialRoute: "/test",
    );
  }
}

void main() async {
  runApp(Home());
  await AmapService.init(androidKey: '12facb822ab7d73c8501c4014a95a5bf');
  await enableFluttifyLog(false);
}
