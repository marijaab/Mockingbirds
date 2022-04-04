import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/weather.dart';
import 'package:veloplan/providers/weather_manager.dart';
import 'package:veloplan/styles/styling.dart';

/// Shows weather conditions in sidebar.
/// Author: Nicole
/// Contributor: Hristina-Andreea Sararu
class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Weather weather = Weather.defaultvalue();
  String weatherIcon = "10n";
  WeatherManager _weatherManager = WeatherManager();
  // Timer? timer;
  LatLng currentPosition = getLatLngFromSharedPrefs();

  @override
  void initState() {
    _weatherManager
        .importWeatherForecast(
            currentPosition.latitude, currentPosition.longitude)
        .then((value) {
      if (mounted)
        setState(() {
          this.weather = _weatherManager.all_weather_data;
          this.weatherIcon = _weatherManager.all_weather_data.current_icon;
        });
    });
    // startWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteReplacement,
      appBar: AppBar(
        leading: BackButton(key: Key("back"), color: Colors.white),
        title: const Text('Weather'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 30),
            SizedBox(
                key: Key("weatherIcon"),
                child: Center(
                  child: Image.network(
                    //late problem sort it
                    'http://openweathermap.org/img/w/${weather.current_icon}.png',
                    scale: 0.3,
                  ),
                )),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                key: Key("weatnerInfo"),
                children: [
                  SizedBox(height: 50),
                  Text(
                    weather.current_description,
                    style: weatherTextStyle,
                  ),
                  Text(
                    "Temperature: " +
                        weather.getCurrentWeatherTemp().toInt().toString() +
                        "C",
                    style: weatherTextStyle,
                  ),
                  Text(
                    "Feels like: " +
                        weather
                            .getCurrentFeelsLikeTemp()
                            .roundToDouble()
                            .toString() +
                        "C",
                    style: weatherTextStyle,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Clouds: " + weather.getCurrentClouds().toString(),
                    style: weatherTextStyle,
                  ),
                  Text(
                    "Visibility: " + weather.getCurrentVisibility().toString(),
                    style: weatherTextStyle,
                  ),
                  Text(
                    "Wind speed: " +
                        weather
                            .getCurrentWindSpeed()
                            .roundToDouble()
                            .toString(),
                    style: weatherTextStyle,
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}