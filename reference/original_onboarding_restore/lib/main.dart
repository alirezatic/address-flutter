import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

import 'package:address/app/app.dart';
import 'package:address/core/localization/app_locale_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await rive.RiveNative.init();
  await AppLocaleController.instance.load();

  runApp(const AddressApp());
}
