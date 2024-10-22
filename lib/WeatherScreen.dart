import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';


class WeatherScreen extends StatefulWidget {
  WeatherScreen({ required this.weather});

  final Weather weather;

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: new Color(0xffffffff),
              gradient: getGradientByMood(widget.weather)),
        ),
        Align(
          alignment: FractionalOffset.center,
          //Aligment musi być zrobiony na kontenerze jak i na elemencie
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, //element kontenera
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 45.0)),
              Image(
                image: AssetImage('icons/${getIconByMood(widget.weather)}.png'),
              ),
              Padding(padding: EdgeInsets.only(top: 41.0)),
              Text("${DateFormat.MMMMEEEEd('pl').format(DateTime.now())}, ${widget.weather.weatherDescription}",
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 14.0,
                  height: 1.2,
                  color: Colors.white,
                  fontWeight: FontWeight.w400
                )
              ),),
              Padding(padding: EdgeInsets.only(top: 12.0)),
              Text('${widget.weather.temperature!.celsius!.floor().toString()}°C',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 64.0,
                          height: 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.w700
                      )
                  )),
              Text('Odczuwalna ${widget.weather.tempFeelsLike!.celsius!.floor().toString()}°C',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 14.0,
                          height: 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.w700
                      )
                  )),
              Padding(padding: EdgeInsets.only(top: 25.0)),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Ciśnienie",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 14.0,
                                        height: 1.2,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300
                                    )
                                )),
                            Padding(padding: EdgeInsets.only(top:2.0)),
                            Text("${widget.weather.pressure!.floor()}hPa",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 26.0,
                                        height: 1.2,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700
                                    )
                                ))
                          ],
                        ),
                    ),
                    VerticalDivider(
                      width: 48,
                      color: Colors.white,
                      thickness: 1,
                    ),
                    Container(
                      width: 130,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Wiatr",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 14.0,
                                      height: 1.2,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300
                                  )
                              )),
                          Padding(padding: EdgeInsets.only(top:2.0)),
                          Text("${widget.weather.windSpeed!.floor()} m/s",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 26.0,
                                      height: 1.2,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700
                                  )
                              ))
                        ],
                      ),
                    )
                  ],
                )
              ),
              Padding(padding: EdgeInsets.only(top: 24.0)),
              if(widget.weather.rainLastHour!=null)//interfejs warunkowy
              Text("Opady ${widget.weather.rainLastHour} mm/1h",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 14.0,
                          height: 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.w400
                      )
                  )),
              Padding(padding: EdgeInsets.only(top: 68.0)),
            ],
          ),
        ),
      ]),
    );
  }

  String getIconByMood(Weather weather) {
    var main = weather.weatherMain;
    if(main == 'Clouds' || main == 'Drizzle' || main == "Snow"){
      return 'weather-rain';
    }else if(main == 'Thunderstorm'){
      return 'weather-lightning';
    } else if(isNight(weather)){
      return 'weather-moonny';
    }else{
      return 'weather-sunny';
    }
  }



  bool isNight(Weather weather) {
      return DateTime.now().isAfter(weather.sunset ?? DateTime.now()) ||
          DateTime.now().isBefore(weather.sunrise ?? DateTime.now());
  }

  LinearGradient getGradientByMood(Weather weather) {
    var main = weather.weatherMain;
    if(main == 'Clouds' || main == 'Drizzle' || main == "Snow"){
      return LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            new Color(0xff6E6Cd8),
            new Color(0xff40A0EF),
            new Color(0xff77E1EE)
          ]
      );
    }else if(main == 'Tunderstorm' || isNight(weather)){
      return LinearGradient(
        //liniowy gradient
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            new Color(0xff313545),
            new Color(0xff121118)
          ]
      );
    }
    else {
      return LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            new Color(0xff5283F0),
            new Color(0xffCDEDD4)
          ]
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }
}