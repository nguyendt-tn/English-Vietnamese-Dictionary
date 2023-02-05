import 'package:flutter/material.dart';

import 'package:dictionary/core/models/dictionary.dart';
import 'package:dictionary/core/representation/screens/dictionary_screens/dictionary_result.dart';
import 'package:dictionary/core/representation/screens/favorite_screens/favorite_screen.dart';
import 'package:dictionary/core/representation/screens/main_screen.dart';
import 'package:dictionary/core/representation/screens/recent_screens/recent_screen.dart';
import 'package:dictionary/core/representation/screens/setting_screens/setting_screen.dart';
import 'package:dictionary/core/representation/screens/splash_screen.dart';
import 'package:dictionary/core/representation/screens/translate_screens/translate_result_screen.dart';
import 'package:dictionary/core/representation/screens/translate_screens/translate_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case SpashScreen.routeName:
        return MaterialPageRoute(builder: (context) => SpashScreen());
      case MainScreen.routeName:
        return MaterialPageRoute(builder: (context) => MainScreen());
      case DictionaryResult.routeName:
        var args = setting.arguments as DictionaryModel;
        return MaterialPageRoute(
            builder: (context) => DictionaryResult(result: args));
      case TranslateScreen.routeName:
        return MaterialPageRoute(builder: (context) => TranslateScreen());
      case TranslateResultScreen.routeName:
        var args = setting.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => TranslateResultScreen(
                  result: args['result'],
                  voiceLanguageCode: args['voiceLanguageCode'],
                ));
      case RecentScreen.routeName:
        return MaterialPageRoute(builder: (context) => RecentScreen());
      case FavoriteScreen.routeName:
        return MaterialPageRoute(builder: (context) => FavoriteScreen());
      case SettingScreen.routeName:
        return MaterialPageRoute(builder: (context) => SettingScreen());
      default:
    }
    return MaterialPageRoute(
        builder: (context) => Scaffold(
              body: Text("No route defined"),
            ));
  }
}
