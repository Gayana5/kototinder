import 'package:flutter/material.dart';

import 'core/di/app_dependencies.dart';
import 'presentation/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = await AppDependencies.initialize();
  runApp(CatTinderApp(dependencies: dependencies));
}
