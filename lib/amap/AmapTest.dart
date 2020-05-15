import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
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
  double height = 500;
  AmapController _controller;
  _navToMyPosition() async {
    LatLng latlng = await _controller.getLocation();
    double leval = await _controller.getZoomLevel();
    print('===================');
    print(latlng);
    _controller.setCenterCoordinate(latlng,zoomLevel: leval);
  }

  @override
  Widget build(BuildContext context) {
    height = height == 500 ? height - 1 : height + 1;
    return Column(
      children: <Widget>[
        Container(
          height: height,
          child:AmapView(
            // 地图类型 (可选)
            mapType:  MapType.Standard,
            // 是否显示缩放控件 (可选)
            showZoomControl: false,
            // 是否显示指南针控件 (可选)
            showCompass: false,
            // 是否显示比例尺控件 (可选)
            showScaleControl: false,
            // 是否使能缩放手势 (可选)
            zoomGesturesEnabled: true,
            // 是否使能滚动手势 (可选)
            scrollGesturesEnabled: true,
            // 是否使能旋转手势 (可选)
            rotateGestureEnabled: false,
            // 是否使能倾斜手势 (可选)
            tiltGestureEnabled: false,
            // 缩放级别 (可选)
            zoomLevel:12,
            // 中心点坐标 (可选)
            centerCoordinate: LatLng(39, 116),
            // 标记 (可选)
            markers: <MarkerOption>[],
            onMapCreated: (controller) async {
              if (await requestPermission())  {
                _controller = controller;
                await controller.showMyLocation(MyLocationOption(show: true,myLocationType: MyLocationType.RotateNoCenter));
                _navToMyPosition();
              }
            },
          ),
        ),
        RaisedButton(
          child: Text('更改颜色'),
          onPressed: () async {
            MapType mapType = await _controller.getMapType();
            if(mapType == MapType.Standard){
              _controller.setMapType(MapType.Night);
            }else{
              _controller.setMapType(MapType.Standard);
            }

          },
        ),
        RaisedButton(
          child: Text('定位到我的位置'),
          onPressed: () async {
            _navToMyPosition();
          },
        ),
        RaisedButton(
          child: Text('设置指示器图标'),
          onPressed: () async {
            _controller.setIconUri(createLocalImageConfiguration(context), Uri.parse('images/test_icon.png'),);
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
      initialRoute: "/home",
    );
  }
}

void main() async {
  runApp(Home());
  await AmapService.init(androidKey: '12facb822ab7d73c8501c4014a95a5bf');
  await enableFluttifyLog(false);
}
