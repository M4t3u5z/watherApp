import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/SplashScreen.dart';


import 'main.dart';

class PermissionScreen extends StatefulWidget {
  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
      Container(
        decoration: BoxDecoration(
            color: new Color(0xffffffff),
            gradient: LinearGradient(
                //liniowy gradient
                begin: Alignment.centerRight,
                //przejście gradientu od prawej do lewej
                end: Alignment.centerLeft,
                //przejście gradientu od lewej do prawej
                colors: [
                  new Color(0xff6671e5),
                  new Color(0xff4852d9)
                ] //dwa kolory które się mieszają w gradiencie
                )),
      ),
      Align(
        alignment: FractionalOffset.center,
        //Aligment musi być zrobiony na kontenerze jak i na elemencie
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //element kontenera
          children: <Widget>[
            Image(
              image: AssetImage('icons/hand-wave.png'),
            ),
            Padding(padding: EdgeInsets.only(top: 15.0)),
            Text("Hejka!",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50.0,
                        color: Colors.white))),
            Padding(padding: EdgeInsets.only(top: 5.0)),
            Text(
                'Aplikacja ${Strings.appTitle} potrzebuje do działania \nprzybliżonej lokalizacji urządzenia',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.white))),
          ],
        ),
      ),
      Positioned(
          left: 0, //pozycja tekstu przywiewam dane
          bottom: 15, //pozycja tekstu przywiewam dane
          right: 0, //pozycja tekstu przywiewam dane
          child: Container(
            alignment: Alignment.center,
            //tekst musi być wyśrodkowany bo nie jest zbyt długi by być na środku
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(

                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                      padding: WidgetStateProperty.all(
                          EdgeInsets.only(top: 12.0, bottom: 12.0))),
                  child: Text(
                    'Zgoda!',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  onPressed: () async {
                    LocationPermission permission =
                    await Geolocator.requestPermission();
                    if (permission == LocationPermission.always ||
                        permission == LocationPermission.whileInUse) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen()));
                    }
                  },
                )),
          ))
    ]));
  }
}
