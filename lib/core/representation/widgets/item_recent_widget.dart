import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:dictionary/core/constants/color_constants.dart';
import 'package:dictionary/core/constants/dismension_constants.dart';
import 'package:dictionary/core/models/dictionary.dart';
import 'package:dictionary/core/provider/recent_provider.dart';
import 'package:dictionary/core/representation/screens/dictionary_screens/dictionary_result.dart';

class ItemRecentWidget extends StatefulWidget {
  const ItemRecentWidget(
      {Key? key, required this.item, required this.isRecentWidget})
      : super(key: key);
  final DictionaryModel item;
  final bool isRecentWidget;

  @override
  State<ItemRecentWidget> createState() => _ItemRecentWidgetState();
}

class _ItemRecentWidgetState extends State<ItemRecentWidget> {
  bool isListening = false;
  @override
  Widget build(BuildContext context) {
    final screnSize = MediaQuery.of(context).size;
    final recentProvider = Provider.of<RecentProvider>(context, listen: false);
    var item = widget.item;
    return Column(
      children: <Widget>[
        Container(
          width: screnSize.width * 0.9,
          padding: EdgeInsets.all(kDefaultPadding / 2),
          margin: EdgeInsets.only(bottom: kDefaultMargin * 2),
          decoration: BoxDecoration(
            borderRadius: kDefaultBorderRadius,
            color: ColorPalette.backgroundScaffoldColor,
            boxShadow: [
              BoxShadow(
                color: ColorPalette.shadowColor.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: TextButton(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: screnSize.width * 0.5,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: screnSize.width * 0.6,
                        child: Text(
                          item.word,
                          style: GoogleFonts.quicksand(
                              color: Color(0xff668CEA),
                              fontSize: kDefaultFontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: screnSize.width * 0.6,
                        child: Container(
                            child: item.pronunciationUS != ""
                                ? HtmlWidget(
                                    "<span style='font-size:16px;font-weight:400'>${item.pronunciationUS}</span>")
                                : HtmlWidget(
                                    "<span style='font-size:16px;font-weight:400'>${item.word}</span>")),
                      )
                    ],
                  ),
                ),
                SizedBox(
                    child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ColorPalette.primaryColor,
                      borderRadius: kDefaultButtonRadius),
                  child: IconButton(
                    icon: Icon(
                      Icons.volume_up,
                      color: ColorPalette.iconWhiteColor,
                      size: kDefaultIconSize,
                    ),
                    onPressed: () async {
                      setState(() {
                        isListening = true;
                      });
                      setState(() {
                        isListening = true;
                      });
                      FlutterTts flutterTts = FlutterTts();
                      await flutterTts.setLanguage("en-US");
                      await flutterTts.setVoice(
                          {"name": "en-us-x-tpf-network", "locale": "en-US"});
                      await flutterTts.speak(item.word);
                      flutterTts.setCompletionHandler(() {
                        setState(() {
                          isListening = false;
                        });
                      });
                    },
                  ),
                )),
                SizedBox(
                  width: kDefaultMargin,
                ),
                SizedBox(
                    child: Container(
                  alignment: Alignment.center,
                  child: item.isLiked != '' && item.isLiked != 'false'
                      ? IconButton(
                          icon: Icon(
                            Icons.star,
                            color: ColorPalette.primaryColor,
                            size: kMediunIconSize,
                          ),
                          onPressed: () async {
                            if (!widget.isRecentWidget) {
                              await recentProvider.updateRecentById(
                                  item.id, 'false');
                            }
                          })
                      : IconButton(
                          icon: Icon(
                            Icons.star_outline,
                            color: ColorPalette.primaryColor,
                            size: kMediunIconSize,
                          ),
                          onPressed: () async {
                            await recentProvider.updateRecentById(
                                item.id, 'true');
                          },
                        ),
                ))
              ],
            ),
            onPressed: () async {
              if (!mounted) return;
              Navigator.of(context)
                  .pushNamed(DictionaryResult.routeName, arguments: item);
            },
          ),
        ),
      ],
    );
  }
}
