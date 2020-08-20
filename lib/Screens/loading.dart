import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'Homescreen.dart';
import 'package:flutter_ui_music_player/shared/network.dart';

class LoadingScreen extends StatefulWidget {
  String kselcatgry;
  LoadingScreen(this.kselcatgry);
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    int sec = 0;
    Timer.periodic(Duration(seconds: sec += 5), (t) {
      if (networkHelper.songlist.length >= 0) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(widget.kselcatgry)));
        t.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: SpinKitChasingDots(
            color: Colors.grey,
            size: 100.0,
          ),
        ),
      ),
    );
  }
}
