import 'package:flutter/material.dart';
import 'package:veloplan/models/map_models/base_map_with_route_updated_model.dart';
import 'package:veloplan/styles/texts.dart';

/// Displays info about next docking station, distance and time in [MapUpdatedRoutePage].
/// Author: Hristina Andreea Sararu
class JourneyLandingPanelWidget extends StatefulWidget {
  MapWithRouteUpdated baseMapWithUpdatedRoute;

  JourneyLandingPanelWidget(this.baseMapWithUpdatedRoute, {Key? key})
      : super(key: key);

  @override
  _JourneyLandingPanelWidget createState() => _JourneyLandingPanelWidget();
}

class _JourneyLandingPanelWidget extends State<JourneyLandingPanelWidget> {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Journey', style: CustomTextStyles.journeyTextStyle),
          const Divider(
            color: Colors.black,
            thickness: 3,
          ),
          ValueListenableBuilder(
              valueListenable: widget.baseMapWithUpdatedRoute.dockName,
              builder: (BuildContext context, String dockName, Widget? child) {
                return Text(
                  "Next stop: ${dockName}",
                  style: CustomTextStyles.journeyTextStyle,
                  textAlign: TextAlign.center,
                );
              }),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                  valueListenable: widget.baseMapWithUpdatedRoute.duration,
                  builder: (BuildContext context, num time, Widget? child) {
                    String t = (time.toDouble() / 60.0).toStringAsFixed(0);
                    return Row(
                      children: [
                        Icon(
                          Icons.timelapse,
                        ),
                        Text(" Time: ${t} minutes",
                            style: CustomTextStyles.journeyLandingTextStyle),
                        VerticalDivider(
                          color: Colors.black,
                          thickness: 2,
                        )
                      ],
                    );
                  }),
              ValueListenableBuilder(
                valueListenable: widget.baseMapWithUpdatedRoute.distance,
                builder: (BuildContext context, num distance, Widget? child) {
                  return Row(
                    children: [
                      widget.baseMapWithUpdatedRoute.currentStation == 0
                          ? Icon(
                              Icons.directions_walk,
                              size: 22,
                              color: Colors.black,
                            )
                          : ImageIcon(
                              AssetImage("assets/images/bicycle.png"),
                              color: Colors.black,
                              size: 22,
                            ),
                      Text(" Distance: ${distance} m",
                          style: CustomTextStyles.journeyLandingTextStyle)
                    ],
                  );
                },
              )
            ],
          )
        ],
      );
}
