import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:dictionary/core/constants/color_constants.dart';
import 'package:dictionary/core/constants/dismension_constants.dart';

class ItemMenuWidget extends StatelessWidget {
  const ItemMenuWidget(
      {Key? key, required this.icon, required this.title, required this.ontap})
      : super(key: key);

  final IconData? icon;
  final String? title;
  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: ColorPalette.backgroundScaffoldColor,
          borderRadius: kDefaultBorderRadius,
          boxShadow: [
            BoxShadow(
              color: ColorPalette.shadowColor.withOpacity(0.7),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
            vertical: kDefaultPadding * 2, horizontal: kDefaultPadding),
        child: InkWell(
          onTap: ontap,
          child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        icon,
                        size: kDefaultIconSize,
                        color: ColorPalette.primaryColor.withOpacity(0.7),
                      ),
                      SizedBox(
                        width: kDefaultMargin * 2,
                      ),
                      Text(title ?? '',
                          style: GoogleFonts.quicksand(
                              fontSize: kMenuFontSize,
                              color: ColorPalette.textColor,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: kDefaultMargin / 2,
                      ),
                      Icon(Icons.keyboard_arrow_right,
                          color: ColorPalette.textColor.withOpacity(0.7))
                    ],
                  ),
                ))
          ]),
        ));
  }
}
