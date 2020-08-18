import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_rule/src/bloc/bloc.dart';
import 'package:google_maps_rule/src/pages/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarIconBrightness: Brightness.dark));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProviderMaps())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent,
          height: 50,
          textTheme: ButtonTextTheme.primary,
          minWidth: 80,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        )),
        home: SplashScreen(),
      ),
    );
  }
}
