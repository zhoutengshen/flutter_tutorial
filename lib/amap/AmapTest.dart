import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MarkerExtend {
  String color;
  String lat;
  String lng;

  MarkerExtend(this.color, this.lat, this.lng);

  String deJsonStr() {
    Map<String, String> map = {};
    map['color'] = color;
    map['lat'] = lat;
    map['lng'] = lng;
    return jsonEncode(map);
  }

  static MarkerExtend encodeStr(str) {
    Map map = json.decode(str);
    return MarkerExtend(map['color'], map['lat'], map['lng']);
  }
}

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
  List<Marker> _markers = [];
  SmoothMoveMarker smoothMoveMarker;

  initState() {
    super.initState();
  }

  _navToMyPosition() async {
    LatLng latlng = await _controller.getLocation();
    double leval = await _controller.getZoomLevel();
    _controller.setCenterCoordinate(latlng, zoomLevel: leval);
  }

  List<Widget> widgets = [];

  List<Widget> widgetss = [];

  Future<MarkerOption> createMarkerOption(LatLng latlng,
      {Color color = Colors.red}) async {
    MarkerExtend mt = MarkerExtend(color != Colors.blue ? 'red' : 'blue',
        latlng.latitude.toString(), latlng.longitude.toString());
    double width = 50;

    return MarkerOption(
      anchorU: 0.5,
      anchorV: 0.5,
      latLng: latlng,
      object: mt.deJsonStr(),
      widget: Stack(
        children: <Widget>[
          Image.asset(
            'images/position.png',
            height: width,
            width: width,
          ),
          Positioned(
            left: 0,
            top: -4,
            child: Container(
              width: width,
              height: width,
              child: Center(
                child: Text(
                  '周腾深' + _markers.length.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: width / 4.5, color: color),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  setMarkerClickedListener() {
    // 智能注册一次，注册会覆盖上一个函数
    _controller.setMarkerClickedListener((Marker marker) async {
      String meStr = await marker.object;
      MarkerExtend me = MarkerExtend.encodeStr(meStr);
      Color color = me.color == 'red' ? Colors.blue : Colors.red;
      Marker newMarker = await _controller.addMarker(
        await createMarkerOption(
            LatLng(double.parse(me.lat), double.parse(me.lng)),
            color: color),
      );
      _markers.add(newMarker); //添加新的 marker
      //点击移除旧的，以达到视觉上的更改
      marker.remove();
      return false;
    });
  }

  addMarker(latlng) {
    double lat = Random.secure().nextDouble() + latlng.latitude;
    double lon = Random.secure().nextDouble() + latlng.longitude;
    createMarkerOption(LatLng(lat, lon)).then((v) {
      _controller.addMarker(v).then((Marker marker) {
        _markers.add(marker);
        setMarkerClickedListener();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    height = height == 500 ? height - 1 : height + 1;
    return Column(
      children: <Widget>[
        Container(
          height: height,
          child: AmapView(
            // 地图类型 (可选)
            mapType: MapType.Standard,
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
            zoomLevel: 12,
            // 中心点坐标 (可选)
            centerCoordinate: LatLng(39, 116),
            // 标记 (可选)
            markers: <MarkerOption>[],
            onMapCreated: (controller) async {
              if (await requestPermission()) {
                _controller = controller;
                await _controller.showMyLocation(MyLocationOption(
                    show: true, myLocationType: MyLocationType.Follow));
                _navToMyPosition();
              }
            },
          ),
        ),
        Wrap(
          spacing: 10,
          children: <Widget>[
            RaisedButton(
              child: Text('更改颜色'),
              onPressed: () async {
                MapType mapType = await _controller.getMapType();
                if (mapType == MapType.Standard) {
                  _controller.setMapType(MapType.Night);
                } else {
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
                _controller.setIconUri(
                  createLocalImageConfiguration(context),
                  Uri.parse('images/test_icon.png'),
                );
              },
            ),
            RaisedButton(
              child: Text('添加Marker'),
              onPressed: () async {
//                var latlng = await _controller.getLocation();
//                createMarkerOption(latlng).then((MarkerOption option) {
//                  _controller.addMarker(option).then((Marker marker) {
//                    _markers.add(marker);
//                  });
//                });
                LatLng latlng = LatLng(23.099277, 113.324582);
                addMarker(latlng);
              },
            ),
            RaisedButton(
              child: Text('清除marker'),
              onPressed: () {
                _controller.clearMarkers(_markers);
                _markers = [];
              },
            ),
            RaisedButton(
              child: Text('添加smoothMarker'),
              onPressed: () async {
                List<LatLng> path = [];
                path.add(LatLng(23.099277, 113.324582));
                path.add(LatLng(23.099888, 113.325094));
                path.add(LatLng(23.099235, 113.325856));
                path.add(LatLng(23.098275, 113.326508));
                path.add(LatLng(23.097922, 113.327347));
                smoothMoveMarker = await _controller.addSmoothMoveMarker(
                  SmoothMoveMarkerOption(
                    path: path,
                    iconUri: Uri.parse(
                      'images/bus.png',
                    ),
                    imageConfig: createLocalImageConfiguration(context),
                  ),
                );
              },
            ),
            RaisedButton(
              child: Text('清除smoothMoveMarker'),
              onPressed: () {
//                smoothMoveMarker.remove();
              },
            ),
            RaisedButton(
              child: Text('显示我的位置'),
              onPressed: () async {
                await _controller.showMyLocation(MyLocationOption(
                    show: true, myLocationType: MyLocationType.RotateNoCenter));
                _navToMyPosition();
              },
            ),
          ],
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
