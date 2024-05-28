import 'package:permission_handler/permission_handler.dart';

abstract class CameraService {
  Future<void> getPermissions();
}

class CameraServiceImpl implements CameraService {
  CameraServiceImpl();

  @override
  Future<void> getPermissions() async {
    if (await Permission.camera.status.isDenied) {
      await Permission.camera.request();
    }
  }
}
