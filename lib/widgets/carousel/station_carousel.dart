import 'package:flutter/material.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/database_helpers/favourite_helper.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/styles/texts.dart';
import 'package:veloplan/widgets/carousel/custom_carousel.dart';
import 'package:veloplan/widgets/docking_station_card.dart';

/// Class that loads information of docking stations into cards and builds a carousel.
/// Author(s): Tayyibah, Nicole
/// Contributor: Marija
class DockingStationCarousel {
  DockingStationCarousel([this.userCoordinates]);

  final dockingStationManager _stationManager = dockingStationManager();
  late List<Widget> dockingStationCards = [];
  List<Map> carouselData = [];
  LatLng? userCoordinates;
  final _helper = FavouriteHelper(DatabaseManager()); //change name

  /// Generates [dockingStationCards] from the data in [docks].
  List<Widget> createDockingCards(List<DockingStation> docks) {
    for (var station in docks) {
      carouselData.add({'station': station});
    }
    dockingStationCards = List<Widget>.generate(
        docks.length,
        (index) => DockingStationCard.station(
              carouselData[index]["station"],
            ));
    return dockingStationCards;
  }

  /// Builds a carousel out of given [cards].
  Widget buildCarousel(cards) {
    return CustomCarousel(cards: cards);
  }

  /// Builds filtered carousel consisting of cards filtered by [filter].
  FutureBuilder<List<Widget>> buildFilteredCarousel(String filter) {
    return FutureBuilder(
        future: _selectFiltering(filter),
        builder: (context, snapshot) {
          var height = MediaQuery.of(context).size.height * 0.23;
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if (snapshot.data!.length == 0) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/bike.png', height: 100),
                  SizedBox(height: 10),
                  Text('Nothing to see here.',
                      style: CustomTextStyles.placeholderText),
                ],
              );
            } else {
              return Container(
                alignment: Alignment.center,
                height: height,
                child: CustomCarousel(cards: dockingStationCards),
              );
            }
          } else {
            return Container(
              alignment: Alignment.center,
              height: height,
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  /// Based on [filter], selects what cards should be fetched.
  Future<List<Widget>> _selectFiltering(String filter) {
    if (filter == "Distance") {
      return _retrieve10FilteredByDistanceCards();
    } else {
      return _retrieve10FilteredFavouritesCards();
    }
  }

  /// Retrieves 10 filtered by distance cards closest to given [userCoordinates].
  Future<List<Widget>> _retrieve10FilteredByDistanceCards() async {
    return _stationManager.importStations().then((value) => createDockingCards(
        _stationManager.get10ClosestDocks(userCoordinates!)));
  }

  /// Retrieve the filtered cards for edit dock. Get 10 cards that are the closest to the given location
  Future<List<Widget>> _retrieve10FilteredFavouritesCards() async {
    List<DockingStation> favourites = [];
    favourites = await _helper.getUserFavourites();
    final dockingStationManager _stationManager = dockingStationManager();
    return createDockingCards(
        _stationManager.get10ClosestDocksFav(userCoordinates!, favourites));
  }
}
