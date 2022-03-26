import 'package:flutter/material.dart';
import 'package:veloplan/helpers/database_helpers/favourite_helper.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/widgets/docking_station_card.dart';

///Loads users favourited docking stations and displays them in a list view.
///@author Tayyibah Uddin
class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<DockingStation> favourites = [];
  var helper = FavouriteHelper();

  @override
  void initState() {
    FavouriteHelper.getUserFavourites().then((data) {
      setState(() {
        favourites = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: favourites.isEmpty
          ? const Center(child: Text("You haven't added any favourites."))
          : Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: ListView.builder(
                itemCount: favourites.length,
                itemBuilder: (context, index) {
                  return DockingStationCard.station(favourites[index]);
                },
              ),
            ),
      appBar: AppBar(
        title: const Text('My favourites'),
      ),
    );
  }
}
