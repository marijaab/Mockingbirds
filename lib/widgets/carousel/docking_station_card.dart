import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';
import '/models/favourite.dart';
import '/services/favourite_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloplan/models/favourite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

///Creates a card for a docking station, to include its name, number of bikes and empty bikes.

FirestoreHelper helper = FirestoreHelper();

class dockingStationCard extends StatelessWidget {
  final int index;
  final DockingStation station;
  final String id, name, nb_bikes, nb_empty_docks;

  dockingStationCard(
    this.index,
    this.station,
    this.id,
    this.name,
    this.nb_bikes,
    this.nb_empty_docks,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FavoriteButton(valueChanged: (_isFavorite) {
              helper.toggleFavourite(id);
            }),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name),
                  Text('Bike no: $nb_bikes'),
                  Text('Empty: $nb_empty_docks'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
