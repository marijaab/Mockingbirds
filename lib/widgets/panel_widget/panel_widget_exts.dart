import 'package:flutter/material.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart'
    as LatLong;
import 'package:veloplan/alerts.dart';
import '../../models/docking_station.dart';
import '../../providers/docking_station_manager.dart';
import '../../providers/location_service.dart';
import '../../screens/dock_sorter_screen.dart';

///helper class to build the bubble underneath every location TextField
class PanelExtensions {
  final locationService = LocationService();
  BuildContext? context;
  Alerts alert = Alerts();

  PanelExtensions({required this.context});

  static PanelExtensions of({BuildContext? context}) {
    return PanelExtensions(context: context);
  }

  ///builds the bubble which displays the closest docking station from the place specified in the location TextField
  Widget buildDefaultClosestDock(
      TextEditingController editDockTextEditController,
      TextEditingController placeTextController,
      bool isFrom,
      int numberCyclists) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          child: Icon(Icons.subdirectory_arrow_right),
          flex: 0,
        ),
        Expanded(
          child: TextField(
            enabled: false,
            controller: editDockTextEditController,
            decoration: InputDecoration(
              hintText: "Default closest dock",
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: IconButton(
              onPressed: () async {
                if (placeTextController.text.isEmpty) {
                  alert.showSnackBarErrorMessage(
                      context!, alert.fillInLocationBeforeEditingDockMesssage);
                  print("hello");
                  return;
                }

                List temp = await locationService
                    .getPlaceCoords(placeTextController.text);
                checkInputLocation(placeTextController,
                    editDockTextEditController, isFrom, numberCyclists);

                Navigator.push(
                    context!,
                    MaterialPageRoute(
                        builder: (context) =>
                            DockSorterScreen(_latLng(temp.first, temp.last))));
              },
              padding: const EdgeInsets.all(0),
              icon: const Icon(
                Icons.navigate_next_outlined,
              )),
          flex: 0,
        ),
      ],
    );
  }

  LatLong.LatLng _latLng(double lat, double lng) => LatLong.LatLng(lat, lng);

  void checkInputLocation(
      TextEditingController placeTextController,
      TextEditingController editDockTextEditController,
      bool isFrom,
      int numberCyclists) async {
    print("THIS IS CLOSEST DOCK");
    if (placeTextController.text.isEmpty) {
      print("Nothing specified");
    } else {
      print("REACHED METHOD GETCLOSETDOCK");
      List coordPlace = await locationService.getPlaceCoords(
          placeTextController.text); //getting coord of the place [lat,lng]

      fillClosestDockBubble(coordPlace.first, coordPlace.last,
          editDockTextEditController, isFrom, numberCyclists);
    }
  }

  ///Fills in the bubble, which is displayed underneath every textfield, with the name of the docking station which is closest
  ///to the location specfied by the user
  void fillClosestDockBubble(
      double? lat,
      double? lng,
      TextEditingController editDockTextEditController,
      bool isFrom,
      int numberOfCyclists) async {
    LatLong.LatLng latlngPlace =
        LatLong.LatLng(lat!, lng!); //coverting list to latlng
    dockingStationManager _stationManager = dockingStationManager();
    await _stationManager.importStations();
    print(latlngPlace);
    late DockingStation closestDock;
    if (isFrom) {
      closestDock = _stationManager.getClosestDockWithAvailableBikes(
          latlngPlace, numberOfCyclists);
      //toremove
      var test = _stationManager.getClosestDockWithAvailableSpace(
          latlngPlace, numberOfCyclists);
      print(
          "closest dock info  dock with available BIKES ${numberOfCyclists} ${closestDock.name}  compared to the SPACES ${test.name}");
    } else {
      closestDock = _stationManager.getClosestDockWithAvailableSpace(
          latlngPlace, numberOfCyclists);

      //toremove
      var test = _stationManager.getClosestDockWithAvailableBikes(
          latlngPlace, numberOfCyclists);
      print(
          "closest dock info  dock with available SPACES ${numberOfCyclists} ${closestDock.name} compared to the BIKES ${test.name}");
    }
    print("closet dock ${closestDock.name}");
    editDockTextEditController.text = closestDock.name;
  }
}
////////////////////////////- ------------------------------------------------------------------------------------------------------
////////////////////////////- ------------------------------------------------------------------------------------------------------
////////////////////////////- ------------------------------------------------------------------------------------------------------
////////////////////////////- ------------------------------------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart'
//     as LatLong;
// import 'package:veloplan/alerts.dart';
// import '../../models/docking_station.dart';
// import '../../providers/docking_station_manager.dart';
// import '../../providers/location_service.dart';
// import '../../screens/dock_sorter_screen.dart';

// ///helper class to build the bubble underneath every location TextField
// class PanelExtensions {
//   final locationService = LocationService();
//   BuildContext? context;
//   Alerts alert = Alerts();

//   PanelExtensions({required this.context});

//   static PanelExtensions of({BuildContext? context}) {
//     return PanelExtensions(context: context);
//   }

//   ///builds the bubble which displays the closest docking station from the place specified in the location TextField
//   Widget buildDefaultClosestDock(
//       TextEditingController editDockTextEditController,
//       TextEditingController placeTextController) {
//     return Row(
//       mainAxisSize: MainAxisSize.max,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Expanded(
//           child: Icon(Icons.subdirectory_arrow_right),
//           flex: 0,
//         ),
//         Expanded(
//           child: TextField(
//             enabled: false,
//             controller: editDockTextEditController,
//             decoration: InputDecoration(
//               hintText: "Default closest dock",
//               focusedBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(color: Colors.black, width: 2.0),
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: IconButton(
//               onPressed: () async {
//                 if (placeTextController.text.isEmpty) {
//                   alert.showSnackBarErrorMessage(
//                       context!, alert.fillInLocationBeforeEditingDockMesssage);
//                   print("hello");
//                   return;
//                 }

//                 List temp = await locationService
//                     .getPlaceCoords(placeTextController.text);
//                 checkInputLocation(
//                     placeTextController, editDockTextEditController);

//                 Navigator.push(
//                     context!,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             DockSorterScreen(_latLng(temp.first, temp.last))));
//               },
//               padding: const EdgeInsets.all(0),
//               icon: const Icon(
//                 Icons.navigate_next_outlined,
//               )),
//           flex: 0,
//         ),
//       ],
//     );
//   }

//   LatLong.LatLng _latLng(double lat, double lng) => LatLong.LatLng(lat, lng);

//   void checkInputLocation(TextEditingController placeTextController,
//       TextEditingController editDockTextEditController) async {
//     print("THIS IS CLOSET DOCK");
//     if (placeTextController.text.isEmpty) {
//       print("Nothing specified");
//     } else {
//       print("REACHED METHOD GETCLOSETDOCK");
//       List coordPlace = await locationService.getPlaceCoords(
//           placeTextController.text); //getting coord of the place [lat,lng]
//       getClosetDock(
//           coordPlace.first, coordPlace.last, editDockTextEditController);
//       //TO-DO
//       // - change to get closet dock with available bikes after getting num of cyclist
//     }
//   }

//   ///Fills in the bubble, which is displayed underneath every textfield, with the name of the docking station which is closest
//   ///to the location specfied by the user
//   void getClosetDock(double? lat, double? lng,
//       TextEditingController editDockTextEditController) async {
//     LatLong.LatLng latlngPlace =
//         LatLong.LatLng(lat!, lng!); //coverting list to latlng
//     dockingStationManager _stationManager = dockingStationManager();
//     await _stationManager.importStations();
//     print(latlngPlace);
//     DockingStation closetDock = _stationManager.getClosestDock(latlngPlace);
//     print("closet dock ${closetDock.name}");
//     editDockTextEditController.text = closetDock.name;
//   }
// }
