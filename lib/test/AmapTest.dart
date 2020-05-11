import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Entry.dart';

Future<bool> requestPermission() async {
//  final permissions =
//  await PermissionHandler().requestPermissions([PermissionGroup.location]);
  final permissionStatus = await Permission.location.request();
  if (permissionStatus == PermissionStatus.granted) {
    return true;
  } else {
    toast('需要定位权限!');
    return false;
  }
}

class AmapWidget extends StatelessWidget {
  double height = 500;
  @override
  Widget build(BuildContext context) {
    height = height == 500 ? height - 1 : height + 1;
    return Container(
      height: height,
      width: 600,
      child: AmapView(
        // 地图类型 (可选)
        mapType: MapType.Night,
        // 是否显示缩放控件 (可选)
        showZoomControl: true,
        // 是否显示指南针控件 (可选)
        showCompass: true,
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
        // 标识点击回调 (可选)
        onMarkerClicked: (Marker marker) {},
        // 地图点击回调 (可选)
        onMapClicked: (LatLng coord) {},
        // 地图拖动开始 (可选)
        onMapMoveStart: (MapMove move) {},
        // 地图拖动结束 (可选)
        onMapMoveEnd: (MapMove move) {},
        // 地图创建完成回调 (可选)
        onMapCreated: (controller) async {
          // requestPermission是权限请求方法, 需要你自己实现
          // 如果不知道怎么处理, 可以参考example工程的实现, example工程依赖了`permission_handler`插件.
          if (await requestPermission()) {
            await controller.showMyLocation(MyLocationOption(show: true));
          }
        },
      ),
    );
  }
}

void main() async {
  runApp(MyEntry(
    widget: AmapWidget(),
  ));
  await AmapService.init(androidKey: '12facb822ab7d73c8501c4014a95a5bf');
  await enableFluttifyLog(true);
}
