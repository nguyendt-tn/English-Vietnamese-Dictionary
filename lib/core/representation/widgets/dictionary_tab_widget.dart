import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:dictionary/core/constants/color_constants.dart';
import 'package:dictionary/core/constants/dismension_constants.dart';

class DictionaryTabWidget extends StatefulWidget {
  const DictionaryTabWidget(
      {Key? key,
      required this.word,
      required this.pronunciationUK,
      required this.pronunciationUS,
      required this.result})
      : super(key: key);

  final String word;
  final String pronunciationUK;
  final String pronunciationUS;
  final String result;

  @override
  State<DictionaryTabWidget> createState() => _DictionaryTabWidgetState();
}

class _DictionaryTabWidgetState extends State<DictionaryTabWidget> {
  bool _isListenUS = false;
  bool _isListenUK = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          children: <Widget>[
            widget.pronunciationUK != ""
                ? Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: ColorPalette.primaryColor,
                            borderRadius: kDefaultButtonRadius),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            _isListenUK
                                ? Icons.volume_up
                                : Icons.volume_up_outlined,
                            color: ColorPalette.iconWhiteColor,
                            size: kDefaultIconSize,
                          ),
                          onPressed: () async {
                            setState(() {
                              _isListenUK = true;
                            });
                            FlutterTts flutterTts = FlutterTts();
                            await flutterTts.setLanguage('en-GB');
                            await flutterTts.setVoice({
                              "name": "en-gb-x-gbg-network",
                              "locale": "en-GB"
                            });

                            await flutterTts.speak(widget.word);
                            flutterTts.setCompletionHandler(() {
                              setState(() {
                                _isListenUK = false;
                              });
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: kDefaultPadding / 2),
                        alignment: Alignment.center,
                        child: Text(
                          "UK",
                          style: GoogleFonts.quicksand(
                              fontSize: kDefaultFontSize,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )
                : Container(),
            SizedBox(
              height: kDefaultMargin,
            ),
            widget.pronunciationUS != ""
                ? Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: ColorPalette.primaryColor,
                            borderRadius: kDefaultButtonRadius),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            _isListenUS
                                ? Icons.volume_up
                                : Icons.volume_up_outlined,
                            color: Colors.white,
                            size: kDefaultIconSize,
                          ),
                          onPressed: () async {
                            setState(() {
                              _isListenUS = true;
                            });
                            FlutterTts flutterTts = FlutterTts();
                            await flutterTts.setLanguage("en-US");
                            await flutterTts.setVoice({
                              "name": "en-us-x-tpf-network",
                              "locale": "en-US"
                            });
                            await flutterTts.speak(widget.word);
                            flutterTts.setCompletionHandler(() {
                              setState(() {
                                _isListenUS = false;
                              });
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: kDefaultPadding / 2),
                        alignment: Alignment.center,
                        child: Text(
                          "US",
                          style: GoogleFonts.quicksand(
                              fontSize: kDefaultFontSize,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )
                : Container(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                      child: Text(
                    widget.word,
                    style: GoogleFonts.quicksand(
                        fontSize: kMediumFontsize, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    height: kDefaultMargin,
                  ),
                  SizedBox(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      if (widget.pronunciationUK != "")
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: HtmlWidget(
                              '<div style="padding-bottom:.5em;">${widget.pronunciationUK}</div>'),
                        ),
                    ],
                  )),
                  SizedBox(
                    height: kDefaultMargin,
                  ),
                  HtmlWidget(widget.result),
                  SizedBox(
                    height: kDefaultMargin,
                  ),
                ])),
      ),
    );
  }
}
