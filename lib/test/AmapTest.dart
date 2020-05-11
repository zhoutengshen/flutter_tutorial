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
      width: 400,
      child: AmapView(),
    );
  }
}

void main() async {
  runApp(MyEntry(
    widget: AmapWidget(),
  ));
  await AmapService.init(androidKey: '12facb822ab7d73c8501c4014a95a5bf');
  await enableFluttifyLog(false);
}
