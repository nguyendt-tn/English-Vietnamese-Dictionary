import 'dart:convert';

import 'package:dictionary/core/helpers/speech_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:dictionary/core/constants/color_constants.dart';
import 'package:dictionary/core/constants/dismension_constants.dart';
import 'package:dictionary/core/constants/language_constants.dart';
import 'package:dictionary/core/helpers/db_helper.dart';
import 'package:dictionary/core/models/dictionary.dart';
import 'package:dictionary/core/representation/screens/dictionary_screens/dictionary_result.dart';
import 'package:dictionary/core/representation/screens/favorite_screens/favorite_screen.dart';
import 'package:dictionary/core/representation/screens/recent_screens/recent_screen.dart';
import 'package:dictionary/core/representation/screens/setting_screens/setting_screen.dart';
import 'package:dictionary/core/representation/screens/translate_screens/translate_screen.dart';
import 'package:dictionary/core/representation/widgets/item_menu_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const routeName = "/main_screen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool speechEnabled = false;
  var currentBackPressTime;
  final TextEditingController _suggestTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<List<String>> _loadSuggest(String query) async {
    List<String> listwords = [];
    await rootBundle.loadString('assets/words/english.txt').then((q) {
      for (String i in LineSplitter().convert(q)) {
        listwords.add(i);
      }
    });

    listwords.retainWhere((s) => s.contains(query) && s.startsWith(query));
    return listwords;
  }

  Future<void> searchDictionary(String word) async {
    FocusScope.of(context).requestFocus(FocusNode());

    try {
      var result = await DBHelper.selectDictionaryByWord(word);

      if (result.isEmpty) {
        return EasyLoading.showError(translation(context).notFondWord);
      }
      DictionaryModel recentWord = DictionaryModel(
          word: result[0]['word'],
          form: result[0]['form'],
          pronunciationUK: result[0]['pronunciation_uk'],
          pronunciationUS: result[0]['pronunciation_us'],
          definition: result[0]['definitions'],
          similar: result[0]['similar'],
          speciality: result[0]['speciality']);
      if (!mounted) return;
      Navigator.of(context)
          .pushNamed(DictionaryResult.routeName, arguments: recentWord);

      await DBHelper.insertRecent({
        'word': recentWord.word,
        'pronunciationUS': recentWord.pronunciationUS,
        'pronunciationUK': recentWord.pronunciationUK,
        'definition': recentWord.definition,
        'form': recentWord.form,
        'similar': recentWord.similar,
        'speciality': recentWord.speciality,
        'isLiked': recentWord.isLiked ?? 'false'
      });
    } catch (error) {
      return EasyLoading.showError(translation(context).errorMessage);
    }
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      EasyLoading.showToast(translation(context).warningExit);
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future toggleRecording() => SpeechHelper.toggleRecording(
      onResult: (text) => setState(() => _onSpeechResult(text)),
      onListening: (isListening) {});

  void _onSpeechResult(text) {
    speechEnabled = false;
    _suggestTextController.value = TextEditingValue(
      text: text,
      selection: TextSelection.fromPosition(TextPosition(offset: text.length)),
    );
  }

  @override
  void dispose() {
    _suggestTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onWillPop,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
              toolbarHeight: 150,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(kAppbarRadius),
                ),
              ),
              backgroundColor: ColorPalette.appBarColor,
              elevation: 0,
              title: Column(
                children: <Widget>[
                  SizedBox(
                      height: 45,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Dictionary",
                          style: GoogleFonts.laila(
                              fontSize: 25, color: Colors.white),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(children: <Widget>[
                    SizedBox(
                        child: SizedBox(
                            width: screenSize.width * 0.9,
                            height: 40,
                            child: Center(
                                child: TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  autofocus: false,
                                  controller: _suggestTextController,
                                  style: GoogleFonts.quicksand(
                                      fontStyle: FontStyle.italic,
                                      fontSize: kDefaultFontSize),
                                  onSubmitted: (value) async {
                                    await searchDictionary(value);
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: kDefaultInputRadius,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.0),
                                      borderRadius: kDefaultInputRadius,
                                    ),
                                    hintText: translation(context).typeToSearch,
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: ColorPalette.primaryColor,
                                    ),
                                    suffixIcon: _suggestTextController
                                            .text.isEmpty
                                        ? IconButton(
                                            icon: Icon(
                                              speechEnabled
                                                  ? Icons.mic
                                                  : Icons.mic_none,
                                              color: ColorPalette.primaryColor,
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                speechEnabled = true;
                                              });
                                              await toggleRecording();
                                            },
                                          )
                                        : IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Color(0xff668CEA),
                                            ),
                                            onPressed: () {
                                              _suggestTextController.clear();
                                              setState(() {});
                                            },
                                          ),
                                    hintStyle: GoogleFonts.quicksand(
                                        color: ColorPalette.hintTextColor,
                                        fontSize: kDefaultFontSize),
                                    errorBorder: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: kDefaultInputRadius,
                                      borderSide: BorderSide(
                                          color: ColorPalette.primaryColor,
                                          width: kDefaultPadding / 12),
                                    ),
                                    disabledBorder: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.white,
                                    alignLabelWithHint: true,
                                    focusColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: kDefaultPadding / 12),
                                    hintMaxLines: 1,
                                  )),
                              suggestionsCallback: (pattern) async {
                                return await _loadSuggest(pattern);
                              },
                              itemBuilder: (context, itemData) {
                                return Container(
                                  color: Colors.white,
                                  height: 60,
                                  padding: EdgeInsets.all(kDefaultPadding / 3),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: screenSize.width * 0.18,
                                        child: Icon(
                                          Icons.subject,
                                          color: ColorPalette.primaryColor,
                                        ),
                                      ),
                                      SizedBox(
                                          width: screenSize.width * 0.5,
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(itemData,
                                                style: GoogleFonts.quicksand(
                                                    fontSize: kDefaultFontSize,
                                                    color: ColorPalette
                                                        .primaryColor)),
                                          )),
                                      SizedBox(
                                        width: screenSize.width * 0.18,
                                        child: Icon(
                                          Icons.north_east,
                                          color: ColorPalette.primaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              onSuggestionSelected: (suggestion) async {
                                await searchDictionary(suggestion);
                              },
                              noItemsFoundBuilder: (context) {
                                return InkWell(
                                  onTap: () async {
                                    await searchDictionary(
                                        _suggestTextController.text);
                                  },
                                  child: Container(
                                      color: Colors.white,
                                      height: 60,
                                      padding:
                                          EdgeInsets.all(kDefaultPadding / 3),
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: screenSize.width * 0.18,
                                            child: Icon(
                                              Icons.subject,
                                              color: ColorPalette.primaryColor,
                                            ),
                                          ),
                                          SizedBox(
                                              width: screenSize.width * 0.5,
                                              child: Text(
                                                  _suggestTextController.text,
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.quicksand(
                                                      fontSize:
                                                          kDefaultFontSize,
                                                      color: ColorPalette
                                                          .primaryColor))),
                                          SizedBox(
                                            width: screenSize.width * 0.18,
                                            child: Icon(
                                              Icons.north_east,
                                              color: ColorPalette.primaryColor,
                                            ),
                                          )
                                        ],
                                      )),
                                );
                              },
                            ))))
                  ]),
                ],
              )),
          body: SingleChildScrollView(
              child: Container(
                  color: ColorPalette.backgroundScaffoldColor,
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.05,
                      vertical: screenSize.height * 0.05),
                  child: SafeArea(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        SizedBox(
                          height: screenSize.height * 0.025,
                        ),
                        ItemMenuWidget(
                          icon: Icons.translate,
                          title: translation(context).translate,
                          ontap: () {
                            if (!mounted) return;
                            Navigator.of(context)
                                .pushNamed(TranslateScreen.routeName);
                          },
                        ),
                        SizedBox(
                          height: screenSize.height * 0.025,
                        ),
                        ItemMenuWidget(
                          icon: Icons.history,
                          title: translation(context).recentWord,
                          ontap: () {
                            if (!mounted) return;
                            Navigator.of(context)
                                .pushNamed(RecentScreen.routeName);
                          },
                        ),
                        SizedBox(
                          height: screenSize.height * 0.025,
                        ),
                        ItemMenuWidget(
                          icon: Icons.star_outline,
                          title: translation(context).favoriteWord,
                          ontap: () {
                            if (!mounted) return;
                            Navigator.of(context)
                                .pushNamed(FavoriteScreen.routeName);
                          },
                        ),
                        SizedBox(
                          height: screenSize.height * 0.025,
                        ),
                        ItemMenuWidget(
                          icon: Icons.settings,
                          title: translation(context).setting,
                          ontap: () {
                            if (!mounted) return;
                            Navigator.of(context)
                                .pushNamed(SettingScreen.routeName);
                          },
                        ),
                      ])))),
        ),
      ),
    );
  }
}
