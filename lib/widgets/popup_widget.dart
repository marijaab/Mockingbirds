import 'package:flutter/material.dart';
import 'package:veloplan/styles/styling.dart';
import 'package:veloplan/styles/texts.dart';
import 'package:veloplan/utilities/enums/alert_type.dart';

/// Creates a generic popup widget.
///
/// To avoid distorting the widget, there should be no more than
/// two [PopupButtonWidget]s passed in [PopupWidget.children] property.
///
/// This widget has [type] property of [AlertType]. It determines the
/// image that should be rendered for the widget.
/// Author: Marija
class PopupWidget extends StatelessWidget {
  PopupWidget({
    required this.key,
    required this.title,
    required this.text,
    required this.children,
    required this.type,
  });

  final Key key;
  final String title;
  final String text;
  final List<PopupButtonWidget> children;
  final AlertType type;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Column(children: [
          Container(
            height: MediaQuery.of(context).size.height / 3.50,
          ),
          AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 0.0),
            titlePadding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0.0),
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10.0, right: 10.0, left: 10.0),
                  child: Text(text, textAlign: TextAlign.center),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  decoration: const BoxDecoration(
                    color: Color(0XFFF1F5F8),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: children,
                  ),
                ),
              ],
            ),
          ),
        ]),
        Align(
          alignment: const Alignment(0, -0.37),
          child: Image.asset(type.imagePath, height: 72),
        ),
      ],
    );
  }
}

/// Generates a button for [PopupWidget].
class PopupButtonWidget extends StatelessWidget {
  const PopupButtonWidget({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 5, left: 5),
        child: TextButton(
          style: popupDialogButtonStyle,
          onPressed: onPressed,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: CustomTextStyles.popupDialogButtonTextStyle,
          ),
        ),
      ),
    );
  }
}
