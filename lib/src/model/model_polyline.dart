import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mpolyline {
   int id;
    List<LatLng> point;
    Mpolyline({
        this.id,
        this.point,
    });
    @override
  String toString() {
    return '{ ${this.id}, ${this.point.length}';
  }
}