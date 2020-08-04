import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_rule/src/utils/paintercircle.dart';
import 'package:google_maps_rule/src/utils/paintermarker.dart';
import 'package:google_maps_rule/src/utils/math.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProviderMaps with ChangeNotifier {
  LatLng _initialposition = LatLng(-12.122711, -77.027475);
  String distance;
  double lat1, lon1;
  double lat2, lon2;
  List<LatLng> polylines = [];
  GoogleMapController _mapController;
  LatLng get initialPos => _initialposition;
  final Set<Marker> _markers = Set();
  final Set<Polyline> _polylines = Set();
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyline => _polylines;
  GoogleMapController get mapController => _mapController;
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    controller.setMapStyle(
        '[{"stylers":[{"hue":"#e7ecf0"}]},{"featureType":"administrative","elementType":"labels.text.fill","stylers":[{"color":"#636c81"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#ff0000"}]},{"featureType":"administrative.neighborhood","elementType":"labels.text.fill","stylers":[{"color":"#636c81"}]},{"featureType":"landscape","elementType":"geometry.fill","stylers":[{"color":"#f1f4f6"}]},{"featureType":"landscape","elementType":"labels.text.fill","stylers":[{"color":"#496271"}]},{"featureType":"poi","stylers":[{"visibility":"off"}]},{"featureType":"road","stylers":[{"saturation":-70}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#ffffff"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#c6d3dc"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#898e9b"}]},{"featureType":"transit","stylers":[{"visibility":"off"}]},{"featureType":"water","stylers":[{"saturation":-60},{"visibility":"simplified"}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#d3eaf8"}]}]');
    notifyListeners();
  }

  void addMarkercircle(LatLng location) async {
    final bytes = await _paintercircle();
    _markers.add(Marker(
        anchor: Offset(0.5, 0.5),
        markerId: MarkerId(location.toString()),
        position: location,
        icon: BitmapDescriptor.fromBytes(bytes)));
    notifyListeners();
  }

  void addMarker(LatLng location) async {
    if (markers.length == 0) {
      addMarkercircle(location);
      polylines.add(location);
    } else {
      addMarkercircle(location);
      polylines.add(location);
      addpolyline(polylines);
    }
  }

  void addpolyline(List<LatLng> polylines) {
    _polylines.add(Polyline(
        polylineId: PolylineId(_initialposition.toString()),
        width: 3,
        geodesic: true,
        patterns: [
          PatternItem.dash(10.0),
          PatternItem.gap(10),
        ],
        startCap: Cap.squareCap,
        jointType: JointType.mitered,
        points: polylines,
        visible: true,
        color: Colors.black));
    centralpoint();
    notifyListeners();
  }

  void centralpoint() async {
    lat1 = polylines.elementAt(polylines.length - 2).latitude;
    lon1 = polylines.elementAt(polylines.length - 2).longitude;
    lat2 = polylines.elementAt(polylines.length - 1).latitude;
    lon2 = polylines.elementAt(polylines.length - 1).longitude;
    String distance = Calculations().distance(lat1, lon1, lat2, lon2);
    addMarkerText(distance, lat1, lon1, lat2, lon2);
  }

  void addMarkerText(String distance, double lat1, double lon1, double lat2,
      double lon2) async {
    final bytes = await _paintermarker(distance);
    _markers.add(Marker(
        markerId: MarkerId("distance" + distance.toString()),
        position: Calculations().coordinatecenter(lat1, lon1, lat2, lon2),
        icon: BitmapDescriptor.fromBytes(bytes)));
    notifyListeners();
  }

  void deletemap() {
    markers.clear();
    polylines.clear();
    polyline.clear();
    notifyListeners();
  }

  Future<Uint8List> _paintermarker(String label) async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    Paintermarker paintermarker = Paintermarker(label);
    paintermarker.paint(canvas, Size(250, 100));
    final ui.Image image = await recorder.endRecording().toImage(250, 100);
    final ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }

  Future<Uint8List> _paintercircle() async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    PainterCircle paintermarker = PainterCircle();
    paintermarker.paint(canvas, Size(30, 30));
    final ui.Image image = await recorder.endRecording().toImage(30, 30);
    final ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }
}
