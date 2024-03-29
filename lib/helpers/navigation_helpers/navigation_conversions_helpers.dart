import 'package:flutter_mapbox_navigation/library.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/models/docking_station.dart';

/// Helper methods related to converting LatLng to WayPoints
/// Author(s): Elisabeth Koren Halvorsen k20077737, Fariha Choudhury k20059723, Rahin Ashraf - k20034059

/// Converts a single [latLng] into a WayPoint
WayPoint latLng2WayPoint(LatLng latLng, name) {
  return WayPoint(
      name: name, latitude: latLng.latitude, longitude: latLng.longitude);
}

/// Converts a list of [latLngs] into a list of WayPoint [points]
List<WayPoint> latLngs2WayPoints(List<LatLng> latLngs) {
  List<WayPoint> points = [];
  for (var i = 0; i < latLngs.length; ++i) {
    points.add(WayPoint(
        name: i.toString(),
        latitude: latLngs[i].latitude,
        longitude: latLngs[i].longitude));
  }
  return points;
}

/// Convert a [points] to a LatLng list
List<LatLng>? convertListDoubleToLatLng(List<List<double?>?> points) {
  try {
    List<LatLng> myList = [];
    for (int i = 0; i < points.length; i++) {
      if (!(points[i]?.length == 2)) {
        return null;
      }
      myList.add(LatLng(points[i]?.first as double, points[i]?.last as double));
    }
    return myList;
  } on StateError {
    return null;
  } catch (e) {
    return null;
  }
}

/// Convert a list of [LatLng] points into a list of [double]s
List<List<double?>?>? convertLatLngToDouble(List<LatLng?> points) {
  try {
    List<List<double?>?> myList = [];
    for (int i = 0; i < points.length; i++) {
      myList.add([points[i]?.latitude, points[i]?.longitude]);
    }
    return myList;
  } on StateError {
    return null;
  } catch (e) {
    return null;
  }
}

/// Convert a list of [DockingStation]s into a list of [double]s of the docking station's Latlng
List<List<double?>?>? convertDocksToDouble(List<DockingStation> docks) {
  try {
    List<List<double?>?> myList = [];
    for (int i = 0; i < docks.length; i++) {
      myList.add([docks[i].lat, docks[i].lat]);
    }
    return myList;
  } on StateError {
    return null;
  } catch (e) {
    return null;
  }
}

/// Convert list of [DockingStation]s into a list of [LatLng]s
List<LatLng>? convertDocksToLatLng(List<DockingStation> docks) {
  try {
    List<LatLng> myList = [];
    if (docks.length > 0) {
      for (int i = 0; i < docks.length; i++) {
        myList.add(LatLng(docks[i].lat, docks[i].lon));
      }
    }
    return myList;
  } on StateError {
    return null;
  } catch (e) {
    return null;
  }
}
