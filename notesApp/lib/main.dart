import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.dark(),
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
