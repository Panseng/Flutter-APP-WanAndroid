import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/GlobalConfig.dart';
import 'package:flutter_app/pages/Application.dart';

void main() {
  // 强制竖屏
  SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(primaryColor: GlobalConfig.colorPrimary),
      home: ApplicationPage()
    );
  }
}