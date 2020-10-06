import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:videoapp/screens/Homescreen.dart';
import 'package:videoapp/screens/Splashscreen.dart';

import 'utils/Routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  MyApp({
    Key key,
  }) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        debugShowCheckedModeBanner: false,
        initialRoute: Routes.splash,
        routes: {
          Routes.splash: (context) => Splashscreen(),
          Routes.home: (context) => Home(),
        });
  }
}


