import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/helpers/database_helpers/schedule_helper.dart';
import 'package:veloplan/alerts.dart';
import 'package:veloplan/helpers/live_location_helper.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/providers/location_service.dart';
import 'package:veloplan/screens/journey_planner_screen.dart';
import 'package:veloplan/screens/summary_journey_screen.dart';
import 'package:veloplan/styles/colors.dart';
import 'package:veloplan/styles/styling.dart';
import 'package:veloplan/utilities/dart_exts.dart';
import 'package:veloplan/widgets/dynamic_widget.dart';
import 'package:veloplan/widgets/panel_widget/panel_widgets_base.dart';
import '../../helpers/navigation_helpers/navigation_conversions_helpers.dart';
import '../../models/docking_station.dart';
import '../../providers/location_service.dart';
import '../dynamic_widget.dart';
import 'package:veloplan/helpers/database_helpers/history_helper.dart';
import 'package:veloplan/widgets/panel_widget/panel_widget_exts.dart';

/// Renders [PanelWidget] used in [JourneyPlanner] screen.
///
/// It is an interactive panel the user can slide up or down,
/// when wanting to input their desired locations for the journey.
/// @author: Rahin Ashraf - k20034059
///Contributor: Nicole
class PanelWidget extends PanelWidgetBase {
  PanelWidget(
      {Key? key,
      required Map<String, List<double?>> selectionMap,
      required Stream<MapPlace> address,
      required ScrollController scrollController,
      required StreamController<List<DynamicWidget>> dynamicWidgets,
      required List<DynamicWidget> listDynamic,
      required List<List<double?>?> selectedCoords,
      required Map<String, List<double?>> staticListMap,
      required TextEditingController toTextEditController,
      required int numberOfCyclists,
      required TextEditingController fromTextEditController,
      required PanelController panelController,
      required bool isScheduled,
      required DateTime journeyDate})
      : super(
            selectionMap: selectionMap,
            address: address,
            scrollController: scrollController,
            dynamicWidgets: dynamicWidgets,
            listDynamic: listDynamic,
            selectedCoords: selectedCoords,
            staticListMap: staticListMap,
            toTextEditController: toTextEditController,
            fromTextEditController: fromTextEditController,
            panelController: panelController,
            numberOfCyclists: numberOfCyclists,
            isScheduled: isScheduled,
            journeyDate: journeyDate);
  @override
  PanelWidgetState createState() {
    return PanelWidgetState();
  }

  /// Returns whether or not the user has specified a destination. If not, displays an error message.
  bool hasSpecifiedOneDestination(BuildContext context, Alerts alert) =>
      oneDestinationMustBeSpecified(this, context, alert);

  /// Handles when the user presses a TextField to input a location.
  void handleOnSearchClick(
      BuildContext context,
      TextEditingController textEditingController,
      Function(List<double?>) onAddressAdded) {
    handleSearchClick(this, context, textEditingController, onAddressAdded);
  }
}

class PanelWidgetState extends State<PanelWidget> {
  Stream<List<DynamicWidget>> get dynamicWidgetsStream =>
      widget.dynamicWidgets.stream;
  final locService = LocationService();
  late Map<String, List<double?>> selectionMap;
  late Map<String, List<double?>> staticListMap;
  late Map response;
  final dockingStationManager _stationManager = dockingStationManager();
  final TextEditingController editDockTextEditController =
      TextEditingController();
  static const String fromLabelKey = "From";
  static const String toLabelKey = "To";
  final Alerts alert = Alerts();

  /// Creates a new dynamic widget and adds it to the list of destinations for the journey.
  addDynamic() {
    widget.listDynamic.add(DynamicWidget(
      selectedCoords: widget.selectedCoords,
      coordDataMap: response,
      isFrom: false,
      numberOfCyclists: widget.numberOfCyclists,
    ));
    widget.dynamicWidgets.sink.add(widget.listDynamic);
  }

  /// Imports the docking stations from the TFL API.
  void importDockStation() async {
    await _stationManager.importStations();
    print(_stationManager.stations.length.toString() +
        "this is the length of the stationManager");
  }

  /// Initialises variables and listens for user interaction to act on.
  @override
  void initState() {
    staticListMap = widget.staticListMap;
    selectionMap = widget.selectionMap;
    print(
        "PanelWidgetState => ${widget.numberOfCyclists}"); // access number of cyclists like this
    LatLng currentLocation = getLatLngFromSharedPrefs();
    locService
        .reverseGeoCode(currentLocation.latitude, currentLocation.longitude)
        .then((value) {
      setState(() {
        if (mounted) {
          response = value;
        }
      });
    });
    _listToMapClick();
    importDockStation();
    super.initState();
  }

//TODO what do we do with isFrom here?
  void _listToMapClick() {
    final selectedCoords = widget.selectedCoords;

    widget.address.listen((event) {
      final dynamicWidget = DynamicWidget(
        selectedCoords: selectedCoords,
        coordDataMap: response,
        isFrom: false,
        numberOfCyclists: widget.numberOfCyclists,
      );

      final list = widget.listDynamic;
      if (list.any((element) => element.placeTextController.text.isEmpty)) {
        alert.showSnackBarErrorMessage(
            context, alert.cannotHaveEmptySearchLocationsMessage);
        return;
      }

      dynamicWidget.placeTextController.text = event.address ?? "";
      dynamicWidget.checkInputLocation();
      dynamicWidget.position = widget.listDynamic.length;
      widget.listDynamic.add(dynamicWidget);
      print(
          "DynamicWidget_pos: ${dynamicWidget.position} ${selectedCoords.length} _${widget.listDynamic.length}");

      if (dynamicWidget.position > selectedCoords.length) {
        selectedCoords.add([event.coords?.latitude, event.coords?.longitude]);
      } else {
        selectedCoords.insert(dynamicWidget.position,
            [event.coords?.latitude, event.coords?.longitude]);
      }
      widget.dynamicWidgets.sink.add(widget.listDynamic);
    });
  }

  ///When called, this function sets the first location of the journey to the users current location
  _useCurrentLocationButtonHandler(TextEditingController controller, String key,
      bool isFrom, int numberCyclists) async {
    sharedPreferences.setString('source', json.encode(response));
    String place = response['place'];
    double latitudeOfPlace = response['location'].latitude;
    double longitudeOfPlace = response['location'].longitude;
    List<double?> currentLocationCoords = [latitudeOfPlace, longitudeOfPlace];
    controller.text = place;
    staticListMap[key] = currentLocationCoords;

    PanelExtensions.of().checkInputLocation(
        controller, editDockTextEditController, isFrom, numberCyclists);
  }

  ///Function which builds the static row of components which are displayed permanently. Statically built, as every journey
  ///needs to specify a starting point
  Widget _buildStatic(TextEditingController controller,
      {String? hintText,
      required BuildContext context,
      required String label,
      required bool isFrom,
      required int numberCyclists,
      required Function(List<double?>) onAddressAdded}) {
    return Column(
      children: [
        TextField(
          readOnly: true,
          onTap: () {
            widget.handleOnSearchClick(context, controller, onAddressAdded);
          },
          onEditingComplete: () {
            PanelExtensions.of(context: context).checkInputLocation(controller,
                editDockTextEditController, true, widget.numberOfCyclists);
          },
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: circularInputBorder(),
            focusedBorder:
                circularInputBorder(width: 2.0, color: CustomColors.green),
            disabledBorder: circularInputBorder(),
            suffixIcon: IconButton(
              onPressed: () {
                _useCurrentLocationButtonHandler(
                    controller, label, isFrom, numberCyclists);
              },
              icon:
                  Icon(Icons.my_location, size: 20, color: CustomColors.green),
            ),
          ),
        ),
        PanelExtensions.of(context: context).buildDefaultClosestDock(
            editDockTextEditController, controller, isFrom, numberCyclists),
      ],
    );
  }

  void addCordFrom(List<double?> newCord) {
    staticListMap[fromLabelKey] = newCord;
    //TODO: isFrom is true!!
    print(
        "ONCHANGED getting isFrom!!! ${widget.numberOfCyclists}  in addcoordfrom");
    PanelExtensions.of(context: context).fillClosestDockBubble(newCord[0],
        newCord[1], editDockTextEditController, true, widget.numberOfCyclists);
  }

  void addCordTo(List<double?> newCord) {
    staticListMap[toLabelKey] = newCord;
  }

  void _updateItems(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = widget.listDynamic.removeAt(oldIndex);
    widget.listDynamic.insert(newIndex, item);

    if (oldIndex < widget.selectedCoords.length) {
      final itemCoords = widget.selectedCoords[oldIndex];
      widget.selectedCoords.removeAt(oldIndex);
      widget.selectedCoords.insert(newIndex, itemCoords);
    }
  }

  /// Creates the panel itself.
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.green,
                ),
              ),
              Text(
                "Explore London",
                style: infoTextStyle,
              ),
              SizedBox(width: 5.0),
              Tooltip(
                preferBelow: false,
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                textStyle: TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                  color: CustomColors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                message:
                    'Please specify the starting location of your trip and add destinations by clicking the + button. Tapping on the location in the map is another way of adding a stop to your trip! Ensure there are no blank destinations when you do so. When you are done, click START.',
                showDuration: const Duration(seconds: 3),
                child: const Icon(Icons.info_outline_rounded,
                    size: 20.0, color: Colors.green),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(top: 10.0),
            controller: widget.scrollController,
            children: [
              _buildStatic(widget.fromTextEditController,
                  hintText: "Where from?",
                  label: "From",
                  context: context,
                  onAddressAdded: addCordFrom,
                  isFrom: true,
                  numberCyclists: widget.numberOfCyclists),
              Column(
                children: [
                  StreamBuilder<List<DynamicWidget>>(
                    builder: (_, snapshot) {
                      List<DynamicWidget> listOfDynamics = snapshot.data ?? [];

                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ReorderableListView.builder(
                          itemExtent: 120,
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            final dynamicWidget = listOfDynamics[index];
                            dynamicWidget.position = index;
                            dynamicWidget.removeDynamic((p0) {
                              widget.listDynamic.removeAt(index);
                              widget.dynamicWidgets.sink
                                  .add(widget.listDynamic);
                            });
                            return Container(
                                key: ValueKey(index), child: dynamicWidget);
                          },
                          itemCount: listOfDynamics.length,
                          physics: const NeverScrollableScrollPhysics(),
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              _updateItems(oldIndex, newIndex);
                            });
                          },
                        ),
                      );
                    },
                    stream: dynamicWidgetsStream,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(child: Divider(), width: MediaQuery.of(context).size.width),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildFloatingActionButton(onPressed: addDynamic),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: const Text('OR'),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed:
                      widget.isScheduled ? _handleSaveClick : _handleStartClick,
                  child: widget.isScheduled ? text("SAVE") : text("START"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleSaveClick() async {
    final hasEmptyField = widget.listDynamic
        .any((element) => element.placeTextController.text.isEmpty);

    applyConstraints(
        widget.fromTextEditController, widget.toTextEditController);

    if (hasEmptyField) {
      alert.showSnackBarErrorMessage(
          context, alert.startPointMustBeDefinedMessage);
      return;
    } else if (areAdjacentCoords(widget.selectedCoords)) {
      alert.showSnackBarErrorMessage(context, alert.noAdjacentLocationsAllowed);
      return;
    } else {
      List<List<double?>?> tempList = [];
      tempList.addAll(staticListMap.values);
      tempList.addAll(widget.selectedCoords);

      ScheduleHelper helper = ScheduleHelper();
      helper.createScheduleEntry(
          widget.journeyDate, tempList, widget.numberOfCyclists);
    }
    // Navigate back to the previous screen, useful for tbt
    Navigator.of(context).pop(true);
  }

  /// Deals with the user pressing the START button. Applies the constraints for a journey.
  /// For all the coordinates of the locations the user specified, creates a new list - this new list is a list of all the
  /// closest docking stations for the locations the user specified. This new list is then passed onto [MapRoutePage].
  /// THIS FUNCTION NEEDS TO BE REFACTORED FURTHER
  Future<void> _handleStartClick() async {
    final hasEmptyField = widget.listDynamic
        .any((element) => element.placeTextController.text.isEmpty);

    applyConstraints(
        widget.fromTextEditController, widget.toTextEditController);

    if (hasEmptyField) {
      alert.showSnackBarErrorMessage(
          context, alert.startPointMustBeDefinedMessage);
      return;
    } else if (areAdjacentCoords(widget.selectedCoords)) {
      alert.showSnackBarErrorMessage(context, alert.noAdjacentLocationsAllowed);
      return;
    } else {
      List<List<double?>?> tempList = [];
      tempList.addAll(staticListMap.values);
      tempList.addAll(widget.selectedCoords);
      print("ALL_COORDINATES => $tempList");
      List<LatLng>? points = convertListDoubleToLatLng(tempList);

      List<LatLng> closestDockList = [];
      HistoryHelper historyHelper = HistoryHelper();

      List<DockingStation> selectedDocks = [];
      if (points != null) {
        for (int i = 0; i < points.length; i++) {
          DockingStation closestDock = _stationManager
              .getClosestDock(LatLng(points[i].latitude, points[i].longitude));
          //get the dock
          print("------------- adding dock" + closestDock.name);
          selectedDocks.add(closestDock);
          //get the coord
          closestDockList.add(closestDock.getLatlng());
        }
        print("ALL_COORDINATES FOR CLOSEST DOCKS => $closestDockList");
        print("ALL_DOCKS FOR CLOSEST DOCKS => ${selectedDocks.last.name}");
      }

      List<LatLng> closestDocksWithNoAdjancents = [];
      for (int i = 0; i < closestDockList.length - 1; i++) {
        if (closestDockList[i].latitude == closestDockList[i + 1].latitude &&
            closestDockList[i].longitude == closestDockList[i + 1].longitude) {
          if (closestDocksWithNoAdjancents.contains(closestDockList[i])) {
            print("ALREADY EXISTS");
          } else {
            closestDocksWithNoAdjancents.add(closestDockList[i]);
          }
        }
      }
      print("CLOSESTDOCKS WITH NO ADJACENTS");
      print(closestDocksWithNoAdjancents);

      print("CLOSESTDOCKLIST");
      print(closestDockList);

      if (closestDocksWithNoAdjancents.length == 1) {
        alert.showSnackBarErrorMessage(
            context, alert.adjacentClosestDocksMessage);
        return;
      }

      if (points == null) {
        //! show something went wrong alert
        print("hello");
      } else {
        Itinerary _itinerary = new Itinerary.navigation(
            selectedDocks, points, widget.numberOfCyclists);

        //save the journey into the database
        historyHelper.createJourneyEntry(selectedDocks);

        //! TODO: if response = null, we dont want the pop to be true! talk with elisabeth

        //go to the summary of journey screen
        final response = await context.push(SummaryJourneyScreen(_itinerary));
        if (response || response == null) {
          Navigator.of(context).pop(true);
        } else {
          Navigator.of(context).pop();
        }
      }
    }
  }

  /// Applies all the constraints needed for the panel widget.
  /// If any constraints are broken, program execution terminates and  displays necessary error message to the user.
  void applyConstraints(TextEditingController fromEditingController,
      TextEditingController toEditingController) {
    if (startLocationMustBeSpecified(fromEditingController) ||
        startLocationMustBeSpecified(toEditingController)) {
      return;
    }

    if (widget.hasSpecifiedOneDestination(context, alert)) {
      return;
    }

    if (aSearchBarCannotBeEmpty(widget.listDynamic)) {
      return;
    }
  }

  /// Restricts the user from being able to start a journey with 2 locations in the journey being one after the other.
  bool areAdjacentCoords(List<List<double?>?> myList) {
    for (int i = 0; i < myList.length - 1; i++) {
      if (myList[i]?.first == myList[i + 1]?.first &&
          myList[i]?.last == myList[i + 1]?.last) {
        print("Adjacents exist");
        return true;
      }
    }
    if (myList[0]?.first == staticListMap[fromLabelKey]?.first &&
        myList[0]?.last == staticListMap[fromLabelKey]?.last) {
      print("Adjacents exist2");
      return true;
    }
    print("Adjacents do not exist");
    return false;
  }

  /// Restricts the user from being able to start a journey, with blank location fields.
  bool aSearchBarCannotBeEmpty(List<DynamicWidget>? list) {
    bool isFieldNotEmpty = true;
    if (list == null) {
      alert.showSnackBarErrorMessage(
          context, alert.cannotHaveEmptySearchLocationsMessage);
      return false;
    }
    for (var element in list) {
      if (element.placeTextController.text.isEmpty) {
        isFieldNotEmpty = false;
        return true; // true if there is a TextField that is empty
      }
    }
    if (!isFieldNotEmpty) {
      alert.showSnackBarErrorMessage(
          context, alert.cannotHaveEmptySearchLocationsMessage);
      return false;
    }
    return false;
  }

  /// Restricts the user from being able to start a journey without a starting point.
  bool startLocationMustBeSpecified(
      TextEditingController textEditingController) {
    if (widget.fromTextEditController.text.isEmpty) {
      alert.showSnackBarErrorMessage(
          context, alert.startPointMustBeDefinedMessage);
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
  }
}