import 'dart:convert';
import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/MyHomePage.dart';
import 'package:weather_app/PermissionScreen.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<ServiceStatus>? locationServiceStatusStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Color(0xffffffff),
              gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Color(0xff6671e5),
                    Color(0xff4852d9)
                  ])),
        ),
        Align(
          alignment: FractionalOffset.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage('icons/cloud-sun.png')),
              Padding(padding: EdgeInsets.only(top: 15.0)),
              Text(Strings.appTitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 42.0,
                          color: Colors.white))),
              Padding(padding: EdgeInsets.only(top: 5.0)),
              Text('Aplikacja do monitorowania \n czystości powietrza',
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
            left: 0,
            bottom: 35,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: Text("Przywiewam dane...",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18.0,
                          color: Colors.white))),
            ))
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    monitorLocationServiceStatus();
  }

  @override
  void dispose() {
    locationServiceStatusStream?.cancel();
    super.dispose();
  }

  // Sprawdzenie dostępu do lokalizacji
  void checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Jeśli lokalizacja jest wyłączona, wyświetl dialog
      showLocationDisabledDialog();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PermissionScreen()));
    } else {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        executeOnceAfterBuild();
      });
    }
  }

  // Monitorowanie stanu lokalizacji
  void monitorLocationServiceStatus() {
    locationServiceStatusStream =
        Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
          if (status == ServiceStatus.enabled) {
            // Jeśli lokalizacja zostanie włączona po uruchomieniu aplikacji
            checkPermission();
          }
        });
  }

  // Funkcja uruchamiana po renderowaniu ekranu
  void executeOnceAfterBuild() async {
    try {
      var currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest,
        forceAndroidLocationManager: true,
        timeLimit: Duration(seconds: 5),
      );

      loadLocationData(currentPosition);
    } catch (e) {
      var lastKnownPosition = await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true,
      );

      if (lastKnownPosition != null) {
        loadLocationData(lastKnownPosition);
      } else {
        print("Nie udało się pobrać lokalizacji");
      }
    }
  }

  // Funkcja pobierania danych o lokalizacji i pogodzie
  void loadLocationData(Position value) async {
    var lat = 51.112435520775534;//value.latitude; //dla utomatyczego pobierania z lokalizacji telefonu
    var lon = 17.03606532697526;//value.longitude; //dla utomatyczego pobierania z lokalizacji telefonu
    log(lat.toString() + " x " + lon.toString());

    WeatherFactory wf = WeatherFactory("fe70cf7066ce04948960ba9d0e88f9d6",
        language: Language.POLISH);
    Weather w = await wf.currentWeatherByLocation(lat, lon);
    log(w.toJson().toString());

    var keyword = 'geo:$lat;$lon';
    String _endpoint = 'https://api.waqi.info/feed/';
    var key = '9cd1f46d46c90e648f87f67780d84cc1d12fe086';
    String url = '$_endpoint$keyword/?token=$key';

    http.Response response = await http.get(Uri.parse(url));
    log(response.body.toString());

    Map<String, dynamic> jsonBody = json.decode(response.body);
    AirQuality aq = AirQuality(jsonBody);

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyHomePage(weather: w, air: aq)));
  }

  // Funkcja wyświetlająca dialog o wyłączonej lokalizacji
  void showLocationDisabledDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Lokalizacja wyłączona"),
          content: Text(
              "Proszę włączyć lokalizację, aby aplikacja mogła pobrać dane."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                checkPermission(); // Po zamknięciu dialogu ponownie sprawdzamy dostęp do lokalizacji
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

class AirQuality {
  bool isGood = false;
  bool isBad = false;
  String quality = "";
  String advice = "";
  int aqi = 0;
  int pm25 = 0;
  String station = "";

  AirQuality(Map<String, dynamic> jsonBody) {
    // Pobieramy indeks jakości powietrza (AQI)
    aqi = int.tryParse(jsonBody['data']['aqi'].toString()) ?? -1;
    // Pobieramy wartość PM2.5
    pm25 = int.tryParse(jsonBody['data']['iaqi']['pm25']['v'].toString()) ?? -1;
    station = jsonBody['data']['city']['name'].toString();
    setupLevel(aqi);
  }

  void setupLevel(int aqi) {
    if (aqi <= 100) {
      quality = "Bardzo dobra";
      advice = "Skorzystaj z dobrego powietrza i wyjdź na spacer";
      isGood = true;
    } else if (aqi <= 150) {
      quality = "Nie za dobra";
      advice = "Jeśli tylko możesz zostań w domu, załatwiaj sprawy online";
      isBad = true;
    } else {
      quality = "Bardzo zła!";
      advice = "Zdecydowanie zostań w domu i załatwiaj sprawy online!";
    }
  }
}
