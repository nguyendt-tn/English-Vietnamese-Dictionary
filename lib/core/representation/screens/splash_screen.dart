import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:dictionary/core/constants/language_constants.dart';
import 'package:dictionary/core/constants/color_constants.dart';
import 'package:dictionary/core/helpers/asset_helper.dart';
import 'package:dictionary/core/helpers/image_helper.dart';
import 'package:dictionary/core/representation/screens/main_screen.dart';

class SpashScreen extends StatefulWidget {
  const SpashScreen({Key? key}) : super(key: key);

  static const routeName = "/splash_screen";

  @override
  State<SpashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SpashScreen> {
  @override
  void initState() {
    super.initState();
    importDB();
    redirectIntroScreen();
  }

  void redirectIntroScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
  }

  Future<void> importDB() async {
    Directory? directory = await getExternalStorageDirectory();
    var filePath = Path.join(directory!.path, "dictionary.db");
    if (File(filePath).existsSync()) {
      return;
    } else {
      try {
        EasyLoading.show(status: translation(context).setupData);
        ByteData data = await rootBundle.load('assets/database/dictionary.db');
        List<int> bytes =
            data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);
        await File(filePath).writeAsBytes(bytes);
        EasyLoading.dismiss();
      } catch (error) {
        EasyLoading.showError(translation(context).setupData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: Container(
          color: ColorPalette.backgroundScaffoldColor,
        )),
        Positioned.fill(
            child: ImageHelper.loadFromAsset(AssetHelper.imageBackgroundSplash,
                fit: BoxFit.fitWidth)),
      ],
    );
  }
}
