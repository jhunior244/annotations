import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Home.dart';

void main() => runApp(MaterialApp(
  localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    Locale("pt"),
  ],
  home: Home(),
  debugShowCheckedModeBanner: false,
));


