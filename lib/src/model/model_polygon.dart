import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mpolygon {
    int id;
    List<LatLng> point;
    Mpolygon({
        this.id,
        this.point,
    });
    @override
  String toString() {
    return '{ ${this.id}, ${this.point.length} }';
  }
}
