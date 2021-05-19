import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GeoService {
  // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Future<Position> getCurrentLocation() async {
    var isEnabled = await Geolocator.isLocationServiceEnabled();
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.denied)
      await Permission.location.request();
    Position curLocation;

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      if (isEnabled) {
        curLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        return curLocation;
      } else
        return null;
    } else
      return null;
  }
}
