import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Home.dart';

void main() {
  runApp(new MyApp());
}

final key = new GlobalKey<HomeState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
        Locale("pt"),
    ],
    debugShowCheckedModeBanner: false,
    home: Home(key: key));
  }
}


