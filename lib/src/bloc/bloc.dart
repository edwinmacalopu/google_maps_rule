import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_rule/src/model/model_polygon.dart';
import 'package:google_maps_rule/src/model/model_polyline.dart';
import 'package:google_maps_rule/src/services/api.dart';
import 'package:google_maps_rule/src/utils/paintercircle.dart';
import 'package:google_maps_rule/src/utils/paintermarker.dart';
import 'package:google_maps_rule/src/utils/math.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProviderMaps with ChangeNotifier {
  LatLng _initialposition = LatLng(-12.122711, -77.027475);
  LatLng _positiondirec;
  String distance;
  String _area;
  String _direction;
  bool _circledata = false;
  Color _color=Colors.lightBlue;
  int _idpol = 0;
  int _idpolin = 0;
  double lat1, lon1;
  double lat2, lon2;
  Uint8List _imageby;
  List<Mpolygon> mpolygon = [];
  List<Mpolyline> mpolyline = [];
  bool _detailarea = false;
  bool _customdialog = false;
  bool _selectpolyli = false;
  bool _selectpolyg = false;
  bool _menu = false;
  List<LatLng> polylines = [];
  List<LatLng> polyg = [];
  GoogleMapController _mapController;
  LatLng get initialPos => _initialposition;
  LatLng get positiondirec => _positiondirec;
  bool get circledata => _circledata;
  String get direction => _direction;
  Uint8List get imageby => _imageby;
  bool get customdialog => _customdialog;
  int get idpol => _idpol;
  int get idpolin => _idpolin;
  bool get menu => _menu;
  bool get selectpolyg => _selectpolyg;
  bool get selectpolyli => _selectpolyli;
  bool get detailarea => _detailarea;
  Color get color => _color;
  String get area => _area;
  final Set<Polygon> _polygon = Set();
  final Set<Marker> _markers = Set();
  final Set<Polyline> _polyline = Set();
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyline => _polyline;
  Set<Polygon> get polygon => _polygon;
  GoogleMapController get mapController => _mapController;
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    controller.setMapStyle(
        '[{"stylers":[{"hue":"#e7ecf0"}]},{"featureType":"administrative","elementType":"labels.text.fill","stylers":[{"color":"#636c81"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#ff0000"}]},{"featureType":"administrative.neighborhood","elementType":"labels.text.fill","stylers":[{"color":"#636c81"}]},{"featureType":"landscape","elementType":"geometry.fill","stylers":[{"color":"#f1f4f6"}]},{"featureType":"landscape","elementType":"labels.text.fill","stylers":[{"color":"#496271"}]},{"featureType":"poi","stylers":[{"visibility":"off"}]},{"featureType":"poi.park","stylers":[{"color":"#75d792"},{"lightness":55},{"visibility":"simplified"}]},{"featureType":"road","stylers":[{"saturation":-70}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#ffffff"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#c6d3dc"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#898e9b"}]},{"featureType":"transit","stylers":[{"visibility":"off"}]},{"featureType":"water","stylers":[{"saturation":-60},{"visibility":"simplified"}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#d3eaf8"}]}]');
    notifyListeners();
  }

  void changemenu() {
    if (_menu == false) {
      _selectpolyg = false;
      _selectpolyli = false;
    }
    _selectpolyg = false;
    _menu = !_menu;
    notifyListeners();
  }

  void changestatutpolyg() {
    if (_selectpolyg == false) {
      _selectpolyg = !_selectpolyg;
      _selectpolyli = !_selectpolyg;
      deletemap();
      notifyListeners();
    }
  }

  void changestatupolyli() {
    if (_selectpolyli == false) {
      _selectpolyli = !_selectpolyli;
      _selectpolyg = !_selectpolyli;
      deletemap();
      notifyListeners();
    }
  }

  void changectdialog(bool dialog) {
    _customdialog = dialog;
    notifyListeners();
  }

  void statusarea() {
    _detailarea = !_detailarea;
    notifyListeners();
  }

  void calcarea() async {
    areapolygon(_idpol);
    notifyListeners();
  }

  void changeColor() {
    _color = Color.fromARGB(255, Random().nextInt(255), Random().nextInt(255),
        Random().nextInt(255));
    _polygon.add(Polygon(
        polygonId: PolygonId(_idpol.toString()),
        points: mpolygon.elementAt(_idpol).point,
        geodesic: true,
        consumeTapEvents: false,
        fillColor: _color,
        strokeColor: Colors.black26));
    print(_color);
    notifyListeners();
  }

  void screenshop() async {
    _imageby = await mapController.takeSnapshot();
    notifyListeners();
  }

  void addpolygon(List<LatLng> polyg) {
    _polygon.add(Polygon(
        polygonId: PolygonId(_idpol.toString()),
        points: mpolygon.elementAt(_idpol).point,
        consumeTapEvents: false,
        fillColor: _color,
        strokeColor: Colors.black26));
  }

  void areapolygon(int id) async {
    _direction = await ApiNonimation().getpoints(
        _positiondirec.latitude.toString(),
        _positiondirec.longitude.toString());
    screenshop();
    statusarea();
    polyg = [];
    markers.clear();
    num prueba = Calculations.computeArea(mpolygon.elementAt(id).point);
    _area = prueba.toString() + " m2";
    changectdialog(true);
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
    if (_selectpolyg == true) {
      usepolygon(location);
    } else {
      usepolyli(location);
    }
  }

  void usepolygon(LatLng location) {
    if (markers.length == 0) {
      _positiondirec = location;
      addMarkercircle(location);
      if (_polygon.length > 0) {
        _idpol = _idpol + 1;
      }
      polyg.add(location);
      mpolygon.add(Mpolygon(id: _idpol, point: polyg));
    } else {
      addMarkercircle(location);
      polyg.add(location);
      mpolygon[_idpol] = Mpolygon(id: _idpol, point: polyg);
      addpolygon(polyg);
    }
  }

  void usepolyli(LatLng location) {
    if (markers.length == 0) {
      addMarkercircle(location);
      if (_polyline.length > 0) {
        _idpolin = _idpolin + 1;
      }
      polylines.add(location);
      mpolyline.add(Mpolyline(id: _idpolin, point: polylines));
    } else {
      addMarkercircle(location);
      polylines.add(location);
      mpolyline[_idpolin] = Mpolyline(id: _idpolin, point: polylines);
      addpolyline(polylines);
    }
  }

  void addpolyline(List<LatLng> polylines) {
    _polyline.add(Polyline(
        polylineId: PolylineId(_idpolin.toString()),
        width: 3,
        geodesic: true,
        patterns: [
          PatternItem.dash(10.0),
          PatternItem.gap(10),
        ],
        startCap: Cap.squareCap,
        jointType: JointType.mitered,
        points: mpolyline.elementAt(_idpolin).point,
        visible: true,
        color: Colors.black));
    centralpoint();
    notifyListeners();
  }

  void centralpoint() async {
    lat1 = mpolyline
        .elementAt(_idpolin)
        .point
        .elementAt(mpolyline.elementAt(_idpolin).point.length - 2)
        .latitude;
    lon1 = mpolyline
        .elementAt(_idpolin)
        .point
        .elementAt(mpolyline.elementAt(_idpolin).point.length - 2)
        .longitude;
    lat2 = mpolyline
        .elementAt(_idpolin)
        .point
        .elementAt(mpolyline.elementAt(_idpolin).point.length - 1)
        .latitude;
    lon2 = mpolyline
        .elementAt(_idpolin)
        .point
        .elementAt(mpolyline.elementAt(_idpolin).point.length - 1)
        .longitude;
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
    if (_selectpolyg == true) {
      markers.clear();
      polylines.clear();
      polyline.clear();
      mpolyline.clear();
    } else {
      polyg.clear();
      markers.clear();
    }
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
