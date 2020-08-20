import 'package:flutter/material.dart';
import 'loading.dart';

class SelectLang extends StatefulWidget {
  @override
  _SelectLangState createState() => _SelectLangState();
}

class _SelectLangState extends State<SelectLang> {
  String kLangSel;
  bool isEngSel = true;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isEngSel = false;
                  });
                  Future.delayed(
                      const Duration(milliseconds: 500),
                      () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoadingScreen("ENG")))
                          .then((value) => setState(() {
                                isEngSel = true;
                              })));
                },
                child: buildAnimatedContainer(width, height, "ENGLISH"),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isEngSel = false;
                  });
                  Future.delayed(
                      const Duration(milliseconds: 500),
                      () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoadingScreen("HIN")))
                          .then((value) => setState(() {
                                isEngSel = true;
                              })));
                },
                child: buildAnimatedContainer(width, height, "HINDI"),
              )
            ],
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildAnimatedContainer(
      double width, double height, String cat) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
      width: isEngSel ? width * 0.8 : width * 0.0,
      height: isEngSel ? height * 0.25 : height * 0.0,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF382e2d), Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black87,
                blurRadius: isEngSel ? 30 : 0,
                offset: Offset(isEngSel ? 20 : 0, isEngSel ? 20 : 0))
          ]),
      child: Center(
        child: Text(
          cat,
          style: TextStyle(
            color: Colors.white,
            fontSize: 38,
          ),
        ),
      ),
    );
  }
}
