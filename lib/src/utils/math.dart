import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show asin, atan2, cos, pi, sin, sqrt, tan;
import 'math_util.dart';
class Calculations{
  static const num earthRadius = 6371009.0;
  LatLng coordinatecenter(double lat1,double lon1,double lat2, double lon2){
double degToRadian(final double deg) => deg * (math.pi / 180.0);  
double radianToDeg(final double rad) => rad * (180.0 / math.pi );
double dLon = degToRadian(lon2 - lon1);
    lat1 = degToRadian(lat1);
    lat2 = degToRadian(lat2);
    lon1 = degToRadian(lon1);
    double bx = math.cos(lat2) * math.cos(dLon);
    double by = math.cos(lat2) * math.sin(dLon);
    double lat3 = math.atan2(math.sin(lat1) + math.sin(lat2), math.sqrt((math.cos(lat1) + bx) * (math.cos(lat1) + bx) + by * by));
    double lon3 = lon1 + math.atan2(by, math.cos(lat1) + bx);
    return LatLng(radianToDeg(lat3),radianToDeg(lon3));
  }

  String distance(double lat1, double lon1,double lat2, double lon2){ 
     var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;          
    double res= 12742 * asin(sqrt(a));
    if (res.toString().substring(0,1)=="0"){
          res=(12742 * asin(sqrt(a)))*1000;
          return res.toStringAsFixed(2)+" m";
    }else{
         res=res;
         return res.toStringAsFixed(2)+" Km";
    }
   }

  static num computeArea(List<LatLng> path) => computeSignedArea(path).abs();

  static num computeSignedArea(List<LatLng> path) =>
      _computeSignedArea(path, earthRadius);

  static num _computeSignedArea(List<LatLng> path, num radius) {
    if (path.length < 3) {
      return 0;
    }

    final prev = path.last;
    var prevTanLat = tan((pi / 2 - MathUtil.toRadians(prev.latitude)) / 2);
    var prevLng = MathUtil.toRadians(prev.longitude);
    final total = path.fold<num>(0.0, (value, point) {
      final tanLat = tan((pi / 2 - MathUtil.toRadians(point.latitude)) / 2);
      final lng = MathUtil.toRadians(point.longitude);

      value += _polarTriangleArea(tanLat, lng, prevTanLat, prevLng);

      prevTanLat = tanLat;
      prevLng = lng;

      return value;
    });

    return total * (radius * radius);
  }
  static num _polarTriangleArea(num tan1, num lng1, num tan2, num lng2) {
    final deltaLng = lng1 - lng2;
    final t = tan1 * tan2;
    return 2 * atan2(t * sin(deltaLng), 1 + t * cos(deltaLng));
  }

}