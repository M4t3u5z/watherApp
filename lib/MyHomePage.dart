import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/AirScreen.dart';
import 'package:weather_app/SplashScreen.dart';
import 'package:weather_app/WeatherScreen.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({required this.weather, required this.air});

  final Weather weather;
  final AirQuality air;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _currentIndex = 0;//zainicjowanie zmiennej obecie używanego indeksu
  var screens;

  @override
  void initState() {
    screens = [//stworzenie kolekcji do wywoływania body jako indeks z kolekcji
      AirScreen(air: widget.air),//index 0
      WeatherScreen(weather: widget.weather)//index 1
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(//funkcja tworzy stos indexowany elemętów z którego odzyskuje istniejący elementy by nie tracić danych (żeby ekran ie tworzł się na nowo)
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 38,
        currentIndex: _currentIndex,
        onTap: (index) => setState(()=> _currentIndex = index ),//funkcja lambda po naciśnieciu na okreslony nawigation bar podmienia index z kolekcji
        items: [
          BottomNavigationBarItem(
              icon: Image.asset("icons/house.png"), label: "Powietrze", activeIcon: Image.asset("icons/house-checked.png")),//kolekcja widoku jakości powietrza o indexie 0
          BottomNavigationBarItem(
              icon: Image.asset("icons/cloud.png"), label: "Pogoda", activeIcon: Image.asset("icons/cloud-checked.png")),//kolekcja widoku pogody o indexie 1
        ],
      ),
    );
  }
}