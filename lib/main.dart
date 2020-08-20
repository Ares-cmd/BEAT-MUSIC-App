import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_music_player/Screens/Homescreen.dart';
import 'package:flutter_ui_music_player/Screens/select_category.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF7D9AFF),
        accentColor: Color(0xFF7D9AFF),
      ),
      home: SelectLang(),
    );
  }
}
