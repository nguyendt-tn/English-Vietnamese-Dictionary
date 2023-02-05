import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:dictionary/core/constants/color_constants.dart';
import 'package:dictionary/core/constants/dismension_constants.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({Key? key, required this.title, required this.ontap})
      : super(key: key);

  final String title;
  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        decoration: BoxDecoration(
            borderRadius: kDefaultButtonRadius,
            color: ColorPalette.primaryColor),
        child: Text(
          title,
          style: GoogleFonts.quicksand(
              fontSize: 18, color: ColorPalette.textButtonColor),
        ),
      ),
    );
  }
}
