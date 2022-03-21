import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/carousel/station_carousel.dart';
import 'package:collection/collection.dart';
import 'package:veloplan/models/docking_station.dart';
import '../models/journey.dart';
import 'package:intl/intl.dart';

///Helper functions to add or remove a journey from the database.
///A journey comprises of a list of docking stations and the time the journey was started.
///Author: Tayyibah

class HistoryHelper {
  late CollectionReference _journeys;
  late final _user_id;
  late FirebaseFirestore _db;

  HistoryHelper() {
    _db = FirebaseFirestore.instance;
    _user_id = FirebaseAuth.instance.currentUser!.uid;
    _journeys = _db.collection('users').doc(_user_id).collection('journeys');
  }

  ///Creates a new journey entry and adds the time and docking stations
  void createJourneyEntry(List<DockingStation> dockingStationList) {
    var newJourney = _journeys.doc();
    addJourneyTime(newJourney.id);
    for (DockingStation station in dockingStationList) {
      addDockingStation(station, newJourney.id);
    }
  }

  ///Adds a docking station subcollection to a given journey
  Future<void> addDockingStation(
    DockingStation station,
    documentId,
  ) {
    return _journeys
        .doc(documentId)
        .collection('docking_stations')
        .add({
          'stationId': station.stationId,
          'name': station.name,
          'numberOfBikes': station
              .numberOfBikes, //these will be removed and changed to lat and lng
          'numberOfEmptyDocks': station.numberOfEmptyDocks,
        })
        .then((value) => print("docking station Added"))
        .catchError((error) =>
            print("Failed to add docking station to journey: $error"));
  }

  ///Calculates the date and adds as a field to journey
  Future<void> addJourneyTime(journeyDocumentId) {
    final DateTime timeNow = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedTime = formatter.format(timeNow);
    return _journeys.doc(journeyDocumentId).set({'date': formattedTime});
  }

  ///Gets all of the docking station information from a given journey
  // void getDockingStationsInJourney(journeyDocumentId) async {
  //   List<DockingStation> stationsInJourney = [];

  //   var list = await _journeys
  //       .doc(journeyDocumentId)
  //       .collection('docking_stations')
  //       .get();

  //   list.docs.forEach((doc) {
  //     stationsInJourney.add(DockingStation.map(doc));
  //   });
  //   }
  //   print("STATIONSINJOURNEY:");
  //   print(stationsInJourney);
  // }

  ///Gets all of the docking station information from a given journey
  Future<List<DockingStation>> getDockingStationsInJourney(
      journeyDocumentId) async {
    List<DockingStation> stationsInJourney = [];

    var list = await _journeys
        .doc(journeyDocumentId)
        .collection('docking_stations')
        .get();

    for (DocumentSnapshot doc in list.docs) {
      stationsInJourney.add(DockingStation.map(doc));
    }

    return stationsInJourney;
  }

  ///Gets all of a users journeys
  Future<List<Journey>> getAllJourneyDocuments() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Journey> journeyList = [];

    QuerySnapshot<Object?> journeys = await _journeys.get();
    for (DocumentSnapshot doc in journeys.docs) {
      List<DockingStation> stationList =
          await getDockingStationsInJourney(doc.id);
      journeyList.add(Journey.map(doc, stationList));
    }
    return journeyList;
  }

  Future<List<String>> getAllTimes() async {
    List<String> times = [];
    QuerySnapshot<Object?> journeys = await _journeys.get();

    for (DocumentSnapshot doc in journeys.docs) {
      times.add(doc["date"]);
    }
    return times;
  }

  ///Deletes docking station subcollection and then deletes journey entry
  ///from the database.
  void deleteJourneyEntryWithDockingStations(String journeyDocumentId) async {
    deleteDockingStations(journeyDocumentId);
    deleteJourneyEntry(journeyDocumentId);
  }

  ///Deletes docking station subcollection from a given journey.
  void deleteDockingStations(String journeyDocumentId) async {
    var dockingStations =
        _journeys.doc(journeyDocumentId).collection("docking_stations");

    QuerySnapshot<Object?> dockingStationDocuments =
        await dockingStations.get();

    for (DocumentSnapshot doc in dockingStationDocuments.docs) {
      dockingStations.doc(doc.id).delete();
    }
  }

  ///Deletes a given journey
  void deleteJourneyEntry(String journeyDocumentId) {
    _journeys
        .doc(journeyDocumentId)
        .delete()
        .then((value) => print("deleted"))
        .catchError((error) => print("Failed to delete journey: $error"));
  }
}
// static Future<List<DockingStation>> getUserFavourites() async {
//   List<DockingStation> favourites = [];
//   FirebaseFirestore db = FirebaseFirestore.instance;

//   QuerySnapshot<Object?> docs = await db
//       .collection('users')
//       .doc(getUid())
//       .collection('favourites')
//       .get();
//   for (DocumentSnapshot doc in docs.docs) {
//     favourites.add(DockingStation.map(doc));
//   }
//   return favourites;
// }

///TO DO:
///for each journey a user has we want to get the docking stations and add it to a card
///add it to a carousel
///view a carousel for each journey
///
///

// static void test(List<List<double?>?> list) async {
//   LocationService service = new LocationService();

//   print("HEREEEEEEEEEEE");
//   print(list);
//   List<double?> destination;
//   if (list != null) {
//     for (int i = 0; i < list.length; i++) {
//       var item = list[i];
//       //service.reverseGeoCode(item[0], item[1]);
//       // myList.add(LatLng(points[i]?.first as double, points[i]?.last as double));
//       Map map = await service.reverseGeoCode(
//           list[i]?.first as double, list[i]?.last as double);

//       print(map["name"]);
//     }
//   }
// }
