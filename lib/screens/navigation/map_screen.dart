import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import '../../helpers/database_helpers/database_manager.dart';
import '../../models/map_models/base_map_with_route_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';

import '../../widgets/popup_widget.dart';
import 'turn_by_turn_screen.dart';

/// Map screen focused on a user's live location
/// Author(s): Fariha Choudhury k20059723, Elisabeth Halvorsen k20077737,

const double zoom = 16; //! REMOVE

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng currentLatLng = getLatLngFromSharedPrefs();
  late BaseMapboxMap _baseMap;
  DatabaseManager _databaseManager = DatabaseManager();

  void initState() {
    _deleteOldGroup();
    super.initState();
  }

  Future<void> _deleteOldGroup() async {
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
    var group = await _databaseManager.getByEquality(
        'group', 'code', user.data()!['group']);
    group.docs.forEach((element) {
      Timestamp timestamp = element.data()['createdAt'];
      if (DateTime.now().difference(timestamp.toDate()) > Duration(days: 1)) {
        element.reference.delete();
        _databaseManager.setByKey(
            'users',
            _databaseManager.getCurrentUser()!.uid,
            {'group': null},
            SetOptions(merge: true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ScopedModelDescendant<MapModel>(
        builder: (BuildContext context, Widget? child, MapModel model) {
      _baseMap = BaseMapboxMap(model);
      addPositionZoom();
      return SafeArea(child: Stack(children: _baseMap.getWidgets()));
    }));
  }

  /// add positional zoom to our widgets
  void addPositionZoom() {
    _baseMap.addWidget(Container(
      alignment: Alignment(0.9, 0.90),
      child: FloatingActionButton(
        heroTag: "center_to_current_loaction",
        onPressed: () {
          _baseMap.controller?.animateCamera(
              CameraUpdate.newCameraPosition(_baseMap.cameraPosition));
        },
        child: const Icon(Icons.my_location),
      ),
    ));
  }
}
