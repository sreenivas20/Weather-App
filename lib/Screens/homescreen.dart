import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/constants/constants.dart' as k;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoaded = false;
  num? temp;
  num? press;
  num? hum;
  num? cover;
  String cityname = '';
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    grtcurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xff0093E9),
            Color(0xff80D0C7),
          ], begin: Alignment.bottomLeft, end: Alignment.topRight),
        ),
        child: Visibility(
          visible: isLoaded,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.07,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: TextFormField(
                    onFieldSubmitted: (String value) {
                      setState(() {
                        String s = value.trim();
                        cityname = s;
                        getCityWeather(s);
                        isLoaded = false;
                        controller.clear();
                      });
                    },
                    controller: controller,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search City',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 25,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.location_city_outlined,
                      color: Colors.red,
                      size: 40,
                    ),
                    Text(
                      cityname,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.12,
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade900,
                          offset: Offset(1, 2),
                          blurRadius: 3,
                          spreadRadius: 1),
                    ]),
                child: Row(
                  children: [
                    Image(
                      image:
                          AssetImage('lib/assets/images/Thermometer image.jpg'),
                      // width: MediaQuery.of(context).size.width * 0.08,
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Temperature: ${temp?.toStringAsFixed(2)} ℃ ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.12,
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade900,
                          offset: Offset(1, 2),
                          blurRadius: 3,
                          spreadRadius: 1),
                    ]),
                child: Row(
                  children: [
                    const Image(
                      image:
                          AssetImage('lib/assets/images/barometter image.jpeg'),
                      // width: MediaQuery.of(context).size.width * 0.08,
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Pressure: ${press?.toStringAsFixed(2)} hPa',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.12,
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade900,
                          offset: Offset(1, 2),
                          blurRadius: 3,
                          spreadRadius: 1),
                    ]),
                child: Row(
                  children: [
                    const Image(
                      image: AssetImage('lib/assets/images/rain drop.jpg'),
                      // width: MediaQuery.of(context).size.width * 0.08,
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Humidity: ${hum?.toInt()} %',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.12,
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade900,
                          offset: Offset(1, 2),
                          blurRadius: 3,
                          spreadRadius: 1),
                    ]),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Image(
                        image: AssetImage(
                            'lib/assets/images/could cover image.jpg'),
                        // width: MediaQuery.of(context).size.width * 0.08,

                        width: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Cloud cover: ${cover?.toInt()} %',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  grtcurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        forceAndroidLocationManager: true);
    if (position != null) {
      log('Lat:${position.latitude}, Long:${position.longitude}');
      getCurrentCityWeather(position);
    } else {
      log('Data unavailable');
    }
  }

  getCityWeather(String cityname) async {
    var client = http.Client();
    var uri = '${k.domain}q=$cityname&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);

    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = jsonDecode(data);
      log(data);
      updateUI(decodedData);
      setState(() {
        isLoaded = true;
      });
    } else {
      log('Error : ${response.statusCode}');
    }
  }

  getCurrentCityWeather(Position position) async {
    var client = http.Client();
    var uri =
        '${k.domain}lat=${position.latitude}&lon=${position.longitude}&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);

    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = jsonDecode(data);
      log(data);
      updateUI(decodedData);
      setState(() {
        isLoaded = true;
      });
    } else {
      log('Error : ${response.statusCode}');
    }
  }

  updateUI(var decodedData) {
    setState(() {
      if (decodedData == null) {
        temp = 0;
        press = 0;
        hum = 0;
        cover = 0;
        cityname = 'Not Available';
      } else {
        temp = decodedData['main']['temp'] - 273;
        press = decodedData['main']['pressure'];
        hum = decodedData['main']['humidity'];
        cover = decodedData['clouds']['all'];
        cityname = decodedData['name'];
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
