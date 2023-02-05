import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:dictionary/core/constants/color_constants.dart';
import 'package:dictionary/core/constants/dismension_constants.dart';
import 'package:dictionary/core/constants/language_constants.dart';
import 'package:dictionary/core/provider/recent_provider.dart';
import 'package:dictionary/core/representation/widgets/item_recent_widget.dart';

class RecentScreen extends StatefulWidget {
  const RecentScreen({Key? key}) : super(key: key);
  static const routeName = "/recent_screen";

  @override
  State<RecentScreen> createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screnSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(kAppbarRadius),
            ),
          ),
          backgroundColor: ColorPalette.primaryColor,
          title: Text(
            translation(context).recentWord,
            style: GoogleFonts.quicksand(color: ColorPalette.appbarTextColor),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
            color: ColorPalette.backgroundScaffoldColor,
            padding: EdgeInsets.symmetric(
                horizontal: screnSize.width * 0.05,
                vertical: screnSize.height * 0.05),
            child: SafeArea(
              child: Consumer<RecentProvider>(
                  builder: (context, recentProvider, child) {
                recentProvider.selectRecents();
                return recentProvider.itemRecents.isEmpty
                    ? Center(
                        child: Text(translation(context).notFoundFavorite,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                                fontSize: kDefaultFontSize)),
                      )
                    : ListView.builder(
                        itemCount: recentProvider.itemRecents.length,
                        itemBuilder: (context, index) {
                          return ItemRecentWidget(
                            item: recentProvider.itemRecents[index],
                            isRecentWidget: true,
                          );
                        },
                      );
              }),
            )));
  }
}
