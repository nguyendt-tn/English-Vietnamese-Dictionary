import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:dictionary/core/constants/language_constants.dart';
import 'package:dictionary/core/provider/recent_provider.dart';
import 'package:dictionary/core/representation/screens/splash_screen.dart';
import 'package:dictionary/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RecentProvider()),
        ],
        builder: (context, child) => MaterialApp(
              title: 'Dictionary',
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: _locale,
              theme: ThemeData(
                scaffoldBackgroundColor: const Color(0xFFFFFFFF),
                backgroundColor: const Color(0xFFFFFFFF),
              ),
              onGenerateRoute: Routes.generateRoute,
              initialRoute: SpashScreen.routeName,
              debugShowCheckedModeBanner: false,
              builder: EasyLoading.init(),
            ));
  }
}
