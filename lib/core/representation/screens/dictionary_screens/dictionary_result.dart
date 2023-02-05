import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity/connectivity.dart';

import 'package:dictionary/core/constants/color_constants.dart';
import 'package:dictionary/core/constants/dismension_constants.dart';
import 'package:dictionary/core/constants/language_constants.dart';
import 'package:dictionary/core/models/dictionary.dart';
import 'package:dictionary/core/representation/widgets/dictionary_tab_widget.dart';

class DictionaryResult extends StatefulWidget {
  const DictionaryResult({Key? key, required this.result}) : super(key: key);
  static const routeName = "/dictionary_result_screen";
  final DictionaryModel result;

  @override
  State<DictionaryResult> createState() => _DictionaryResultState();
}

class _DictionaryResultState extends State<DictionaryResult> {
  int numTab = 0;
  bool isConnect = false;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> networkSubscription;
  WebViewController oxfordController = WebViewController();
  WebViewController wikiController = WebViewController();

  @override
  void initState() {
    super.initState();
    initTabLength();
    initConnectivity();
    initWebview();

    networkSubscription =
        _connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  void initWebview() {
    oxfordController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            oxfordController.runJavaScript(
                'document.querySelector("#onetrust-accept-btn-handler").click()');
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(
          'https://www.oxfordlearnersdictionaries.com/search/english/direct/?q=${widget.result.word}'));

    wikiController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            oxfordController.runJavaScript(
                'document.querySelector("#onetrust-accept-btn-handler").click()');
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(
          'https://www.google.com/search?q=${widget.result.word}&tbm=isch'));
  }

  void initTabLength() {
    if (widget.result.form != "") numTab++;
    if (widget.result.definition != "") numTab++;
    if (widget.result.similar != "") numTab++;
    if (widget.result.speciality != "") numTab++;
    if (widget.result.pronunciationUK != "" ||
        widget.result.pronunciationUS != "") {
      numTab++;
    }
    numTab += 1;
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return updateConnectionStatus(result);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      setState(() {
        isConnect = false;
      });
    } else {
      setState(() {
        isConnect = true;
      });
    }
  }

  @override
  void dispose() {
    networkSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: numTab,
        child: Scaffold(
          appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(kAppbarRadius / 2),
              ),
            ),
            title: Text(
              widget.result.word,
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold, fontSize: kMediumFontsize),
            ),
            backgroundColor: ColorPalette.appBarColor,
            bottom: TabBar(
              isScrollable: true,
              // unselectedLabelColor: Colors.black,
              indicatorColor: ColorPalette.tabUnderlineColor,
              tabs: [
                if (widget.result.definition != "")
                  Tab(
                    text: "ENG- VIE",
                  ),
                if (widget.result.form != "")
                  Tab(
                    text: "GRAMMAR",
                  ),
                if (widget.result.similar != "")
                  Tab(
                    text: "SYNONYMS",
                  ),
                if (widget.result.speciality != "")
                  Tab(
                    text: "SPECIALIZED",
                  ),
                if (widget.result.pronunciationUK != "" ||
                    widget.result.pronunciationUS != "")
                  Tab(
                    text: "OXFORD",
                  ),
                Tab(
                  text: "HÌNH ẢNH",
                )
              ],
            ),
          ),
          body: TabBarView(children: <Widget>[
            if (widget.result.definition != "")
              DictionaryTabWidget(
                  word: widget.result.word,
                  pronunciationUK: widget.result.pronunciationUK,
                  pronunciationUS: widget.result.pronunciationUS,
                  result: widget.result.definition),
            if (widget.result.form != "")
              DictionaryTabWidget(
                  word: widget.result.word,
                  pronunciationUK: widget.result.pronunciationUK,
                  pronunciationUS: widget.result.pronunciationUS,
                  result: widget.result.form),
            if (widget.result.similar != "")
              DictionaryTabWidget(
                  word: widget.result.word,
                  pronunciationUK: widget.result.pronunciationUK,
                  pronunciationUS: widget.result.pronunciationUS,
                  result: widget.result.similar),
            if (widget.result.speciality != "")
              DictionaryTabWidget(
                  word: widget.result.word,
                  pronunciationUK: widget.result.pronunciationUK,
                  pronunciationUS: widget.result.pronunciationUS,
                  result: widget.result.speciality),
            if (widget.result.pronunciationUK != "" ||
                widget.result.pronunciationUS != "")
              Stack(
                children: <Widget>[
                  isConnect == true
                      ? WebViewWidget(
                          controller: oxfordController,
                        )
                      : Center(
                          child: Text(translation(context).errorConnection),
                        ),
                ],
              ),
            Stack(
              children: <Widget>[
                isConnect == true
                    ? WebViewWidget(
                        controller: wikiController,
                      )
                    : Center(
                        child: Text(translation(context).errorConnection),
                      ),
              ],
            )
          ]),
        ));
  }
}
