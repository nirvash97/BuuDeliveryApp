import 'dart:math';

class MyAPI {
  MyAPI();

   double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
  }

    int findDeliveryCost(double distance) {
    int cost;
    if (distance < 1.0) {
      cost = 35;
      return cost;
    } else {
      cost = 35 + ((distance - 1).round() * 10);
      return cost;
    }
  }
}
