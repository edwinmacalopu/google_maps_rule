import 'dart:math';

class MathUtil {
  static num toRadians(num degrees) => degrees / 180.0 * pi;

  static num toDegrees(num rad) => rad * (180.0 / pi);
 
  static num clamp(num x, num low, num high) =>
      x < low ? low : (x > high ? high : x);
 
  static num wrap(num n, num min, num max) =>
      (n >= min && n < max) ? n : (mod(n - min, max - min) + min);
 
  static num mod(num x, num m) => ((x % m) + m) % m;

  
  static num mercator(num lat) => log(tan(lat * 0.5 + pi / 4));
 
  static num inverseMercator(num y) => 2 * atan(exp(y)) - pi / 2;
 
  static num hav(num x) => sin(x * 0.5) * sin(x * 0.5);
 
  static num arcHav(num x) => 2 * asin(sqrt(x));

  static num sinFromHav(num h) => 2 * sqrt(h * (1 - h));  

  static num havFromSin(num x) => (x * x) / (1 + sqrt(1 - (x * x))) * .5;
  static num sinSumFromHav(num x, num y) {
    final a = sqrt(x * (1 - x));
    final b = sqrt(y * (1 - y));
    return 2 * (a + b - 2 * (a * y + b * x));
  }

  static num havDistance(num lat1, num lat2, num dLng) =>
      hav(lat1 - lat2) + hav(dLng) * cos(lat1) * cos(lat2);
}