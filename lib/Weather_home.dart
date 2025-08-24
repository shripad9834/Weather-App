import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wheather/services.dart';
import 'package:wheather/weather_model.dart';
import 'dart:async';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  late WeatherData weatherInfo;
  bool isLoading = false;

  void myWeather() {
    WeatherServices().fetchWeather().then((value) {
      setState(() {
        weatherInfo = value;
        isLoading = true;
      });
    });
  }

  void scheduleAutoRefresh() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      myWeather();
    });
  }

  @override
  void initState() {
    weatherInfo = WeatherData(
      name: '',
      temperature: Temperature(current: 0.0),
      humidity: 0,
      wind: Wind(speed: 0.0),
      maxTemperature: 0,
      minTemperature: 0,
      pressure: 0,
      seaLevel: 0,
      weather: [],
    );
    myWeather();
    scheduleAutoRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
    DateFormat('EEEE d, MMMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFF676BD0),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: isLoading
              ? WeatherDetail(
            weather: weatherInfo,
            formattedDate: formattedDate,
            formattedTime: formattedTime,
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Loading weather data...",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Icon(
                Icons.cloud,
                color: Colors.white,
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final WeatherData weather;
  final String formattedDate;
  final String formattedTime;
  const WeatherDetail({
    super.key,
    required this.weather,
    required this.formattedDate,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            weather.name,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          "${weather.temperature.current.toStringAsFixed(2)}°C",
          style: const TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (weather.weather.isNotEmpty)
          Text(
            weather.weather[0].main,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: 30),
        Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          formattedTime,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          height: 200,
          width: 200,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/cloudy.png"),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _weatherInfoCard(
                      title: "Wind",
                      value: "${weather.wind.speed} km/h",
                      icon: Icons.wind_power,
                    ),
                    _weatherInfoCard(
                      title: "Max",
                      value: "${weather.maxTemperature.toStringAsFixed(2)}°C",
                      icon: Icons.sunny,
                    ),
                    _weatherInfoCard(
                      title: "Min",
                      value: "${weather.minTemperature.toStringAsFixed(2)}°C",
                      icon: Icons.thermostat,
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _weatherInfoCard(
                      title: "Humidity",
                      value: "${weather.humidity}%",
                      icon: Icons.water_drop,
                    ),
                    _weatherInfoCard(
                      title: "Pressure",
                      value: "${weather.pressure} hPa",
                      icon: Icons.compress,
                    ),
                    _weatherInfoCard(
                      title: "Sea Level",
                      value: "${weather.seaLevel} m",
                      icon: Icons.waves,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _weatherInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'geocoding_service.dart';
// import 'services.dart';
// import 'weather_model.dart';
//
// class WeatherHome extends StatefulWidget {
//   const WeatherHome({super.key});
//
//   @override
//   State<WeatherHome> createState() => _WeatherHomeState();
// }
//
// class _WeatherHomeState extends State<WeatherHome> {
//   late WeatherData weatherInfo;
//   bool isLoading = false;
//   String location = "Mumbai"; // Default location
//
//   @override
//   void initState() {
//     super.initState();
//     // Provide default initialization
//     weatherInfo = WeatherData(
//       name: '',
//       temperature: Temperature(current: 0.0),
//       humidity: 0,
//       wind: Wind(speed: 0.0),
//       maxTemperature: 0.0,
//       minTemperature: 0.0,
//       pressure: 0,
//       seaLevel: 0,
//       weather: [],
//     );
//     fetchWeatherForLocation(location);
//   }
//
//   void fetchWeatherForLocation(String location) async {
//     setState(() {
//       isLoading = false;
//     });
//     try {
//       final coordinates =
//       await GeocodingServices().fetchLatLng(location.trim());
//       final lat = coordinates['lat']!;
//       final lng = coordinates['lng']!;
//       final weather = await WeatherServices().fetchWeatherByCoordinates(lat, lng);
//       setState(() {
//         weatherInfo = weather;
//         isLoading = true;
//       });
//     } catch (e) {
//       print("Error: $e");
//       setState(() {
//         isLoading = true;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedDate =
//     DateFormat('EEEE d, MMMM yyyy').format(DateTime.now());
//     String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF676BD0),
//       appBar: AppBar(
//         backgroundColor: Colors.deepPurple,
//         title: TextField(
//           onSubmitted: (value) {
//             fetchWeatherForLocation(value);
//           },
//           decoration: const InputDecoration(
//             hintText: "Enter location",
//             hintStyle: TextStyle(color: Colors.white54),
//             border: InputBorder.none,
//           ),
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Center(
//           child: isLoading
//               ? WeatherDetail(
//             weather: weatherInfo,
//             formattedDate: formattedDate,
//             formattedTime: formattedTime,
//           )
//               : const CircularProgressIndicator(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
//
//
// class WeatherDetail extends StatelessWidget {
//   final WeatherData weather;
//   final String formattedDate;
//   final String formattedTime;
//   const WeatherDetail({
//     super.key,
//     required this.weather,
//     required this.formattedDate,
//     required this.formattedTime,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           weather.name,
//           style: const TextStyle(
//             fontSize: 25,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           "${weather.temperature.current.toStringAsFixed(2)}°C",
//           style: const TextStyle(
//             fontSize: 40,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         if (weather.weather.isNotEmpty)
//           Text(
//             weather.weather[0].main,
//             style: const TextStyle(
//               fontSize: 20,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         const SizedBox(height: 30),
//         Text(
//           formattedDate,
//           style: const TextStyle(
//             fontSize: 18,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           formattedTime,
//           style: const TextStyle(
//             fontSize: 18,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 30),
//         Container(
//           height: 250,
//           decoration: BoxDecoration(
//             color: Colors.deepPurple,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Center(
//             child: Text(
//               "Humidity: ${weather.humidity}%\nWind Speed: ${weather.wind.speed} km/h",
//               style: const TextStyle(color: Colors.white, fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:intl/intl.dart';
// import 'services.dart';
// import 'geocoding_service.dart';
// import 'weather_model.dart';
//
// class WeatherHome extends StatefulWidget {
//   const WeatherHome({super.key});
//
//   @override
//   State<WeatherHome> createState() => _WeatherHomeState();
// }
//
// class _WeatherHomeState extends State<WeatherHome> {
//   late WeatherData weatherInfo;
//   bool isLoading = false;
//   String cityName = "City Name";
//
//   final TextEditingController _cityController = TextEditingController();
//
//   void myWeather(String inputCity) async {
//     setState(() {
//       isLoading = false;
//     });
//
//     try {
//       final geocodingService = GeocodingServices();
//       final coordinates = await geocodingService.fetchLatLng(inputCity);
//
//       final lat = coordinates['lat']!;
//       final lon = coordinates['lng']!;
//
//       final weatherService = WeatherServices();
//       final weatherData = await weatherService.fetchWeatherByCoordinates(lat, lon);
//
//       // Validate city name
//       if (weatherData.name.toLowerCase() != inputCity.toLowerCase()) {
//         print("Warning: Weather data city name (${weatherData.name}) "
//             "does not match input city name ($inputCity).");
//       }
//
//       setState(() {
//         weatherInfo = weatherData;
//         cityName = weatherData.name;
//         isLoading = true;
//       });
//     } catch (e) {
//       print("Error: $e");
//       setState(() {
//         isLoading = false;
//         cityName = "Error loading weather data";
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     weatherInfo = WeatherData(
//       name: '',
//       temperature: Temperature(current: 0.0),
//       humidity: 0,
//       wind: Wind(speed: 0.0),
//       maxTemperature: 0,
//       minTemperature: 0,
//       pressure: 0,
//       seaLevel: 0,
//       weather: [],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedDate =
//     DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
//     String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Weather App",style: TextStyle(color: Colors.white),),
//         backgroundColor: Colors.deepPurple,
//       ),
//       backgroundColor: const Color(0xFF676BD0),
//       body: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           children: [
//             TextField(
//               controller: _cityController,
//               decoration: InputDecoration(
//                 hintText: "Enter a city name",
//                 hintStyle: const TextStyle(color: Colors.white),
//                 filled: true,
//                 fillColor: Colors.deepPurple[300],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               style: const TextStyle(color: Colors.white),
//               onSubmitted: (value) {
//                 myWeather(value);
//               },
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: isLoading
//                   ? WeatherDetail(
//                 weather: weatherInfo,
//                 formattedDate: formattedDate,
//                 formattedTime: formattedTime,
//               )
//                   : Text(
//                 cityName,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class WeatherDetail extends StatelessWidget {
//   final WeatherData weather;
//   final String formattedDate;
//   final String formattedTime;
//
//   const WeatherDetail({
//     super.key,
//     required this.weather,
//     required this.formattedDate,
//     required this.formattedTime,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Location Name
//         Padding(
//           padding: const EdgeInsets.only(top: 20),
//           child: Text(
//             weather.name,
//             style: const TextStyle(
//               fontSize: 25,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//
//         // Current Temperature
//         Text(
//           "${weather.temperature.current.toStringAsFixed(2)}°C",
//           style: const TextStyle(
//             fontSize: 40,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//
//         // Weather Condition
//         if (weather.weather.isNotEmpty)
//           Text(
//             weather.weather[0].main,
//             style: const TextStyle(
//               fontSize: 20,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//
//         const SizedBox(height: 30),
//
//         // Formatted Date and Time
//         Text(
//           formattedDate,
//           style: const TextStyle(
//             fontSize: 18,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           formattedTime,
//           style: const TextStyle(
//             fontSize: 18,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//
//         const SizedBox(height: 30),
//
//         // Weather Icon (Cloudy)
//         Container(
//           height: 100,
//           width: 100,
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("assets/cloudy.png"),
//             ),
//           ),
//         ),
//
//         const SizedBox(height: 30),
//
//         // Weather Information Cards
//         Container(
//           height: 250,
//           decoration: BoxDecoration(
//             color: Colors.deepPurple,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _weatherInfoCard(
//                       title: "Wind",
//                       value: "${weather.wind.speed} km/h",
//                       icon: Icons.wind_power,
//                     ),
//                     _weatherInfoCard(
//                       title: "Max Temp",
//                       value: "${weather.maxTemperature.toStringAsFixed(2)}°C",
//                       icon: Icons.sunny,
//                     ),
//                     _weatherInfoCard(
//                       title: "Min Temp",
//                       value: "${weather.minTemperature.toStringAsFixed(2)}°C",
//                       icon: Icons.thermostat,
//                     ),
//                   ],
//                 ),
//                 const Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _weatherInfoCard(
//                       title: "Humidity",
//                       value: "${weather.humidity}%",
//                       icon: Icons.water_drop,
//                     ),
//                     _weatherInfoCard(
//                       title: "Pressure",
//                       value: "${weather.pressure} hPa",
//                       icon: Icons.compress,
//                     ),
//                     _weatherInfoCard(
//                       title: "Sea Level",
//                       value: "${weather.seaLevel} m",
//                       icon: Icons.waves,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _weatherInfoCard({
//     required String title,
//     required String value,
//     required IconData icon,
//   }) {
//     return Column(
//       children: [
//         Icon(
//           icon,
//           color: Colors.white,
//         ),
//         const SizedBox(height: 5),
//         Text(
//           value,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//           ),
//         ),
//       ],
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:intl/intl.dart';
// import 'services.dart';
// import 'geocoding_service.dart';
// import 'weather_model.dart';
//
// class WeatherHome extends StatefulWidget {
//   const WeatherHome({super.key});
//
//   @override
//   State<WeatherHome> createState() => _WeatherHomeState();
// }
//
// class _WeatherHomeState extends State<WeatherHome> {
//   late WeatherData weatherInfo;
//   bool isLoading = false;
//   String cityName = "City Name";
//
//   final TextEditingController _cityController = TextEditingController();
//
//   void myWeather(String inputCity) async {
//     setState(() {
//       isLoading = true; // Show progress bar
//     });
//
//     try {
//       final geocodingService = GeocodingServices();
//       final coordinates = await geocodingService.fetchLatLng(inputCity);
//
//       final lat = coordinates['lat']!;
//       final lon = coordinates['lng']!;
//
//       final weatherService = WeatherServices();
//       final weatherData = await weatherService.fetchWeatherByCoordinates(lat, lon);
//
//       setState(() {
//         weatherInfo = weatherData;
//         cityName = weatherData.name;
//         isLoading = false; // Hide progress bar
//       });
//     } catch (e) {
//       print("Error: $e");
//       setState(() {
//         isLoading = false; // Hide progress bar and show error
//         cityName = "Error loading weather data";
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     weatherInfo = WeatherData(
//       name: '',
//       temperature: Temperature(current: 0.0),
//       humidity: 0,
//       wind: Wind(speed: 0.0),
//       maxTemperature: 0,
//       minTemperature: 0,
//       pressure: 0,
//       seaLevel: 0,
//       weather: [],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
//     String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Weather App",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.deepPurple,
//       ),
//       backgroundColor: const Color(0xFF676BD0),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             children: [
//               TextField(
//                 controller: _cityController,
//                 decoration: InputDecoration(
//                   hintText: "Enter a city name",
//                   hintStyle: const TextStyle(color: Colors.white),
//                   filled: true,
//                   fillColor: Colors.deepPurple[300],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 style: const TextStyle(color: Colors.white),
//                 onSubmitted: (value) {
//                   myWeather(value);
//                 },
//               ),
//               const SizedBox(height: 20),
//               Center(
//                 child: isLoading
//                     ? const CircularProgressIndicator(
//                   color: Colors.white, // Show progress bar
//                 )
//                     : WeatherDetail(
//                   weather: weatherInfo,
//                   formattedDate: formattedDate,
//                   formattedTime: formattedTime,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// class WeatherDetail extends StatelessWidget {
//   final WeatherData weather;
//   final String formattedDate;
//   final String formattedTime;
//
//   const WeatherDetail({
//     super.key,
//     required this.weather,
//     required this.formattedDate,
//     required this.formattedTime,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 20),
//           child: Text(
//             weather.name,
//             style: const TextStyle(
//               fontSize: 25,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         Text(
//           "${weather.temperature.current.toStringAsFixed(2)}°C",
//           style: const TextStyle(
//             fontSize: 40,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         if (weather.weather.isNotEmpty)
//           Text(
//             weather.weather[0].main,
//             style: const TextStyle(
//               fontSize: 20,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         const SizedBox(height: 30),
//         Text(
//           formattedDate,
//           style: const TextStyle(
//             fontSize: 18,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           formattedTime,
//           style: const TextStyle(
//             fontSize: 18,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 30),
//         Container(
//           height: 100,
//           width: 100,
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("assets/cloudy.png"),
//             ),
//           ),
//         ),
//         const SizedBox(height: 30),
//         Container(
//           height: 250,
//           decoration: BoxDecoration(
//             color: Colors.deepPurple,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _weatherInfoCard(
//                       title: "Wind",
//                       value: "${weather.wind.speed} km/h",
//                       icon: Icons.wind_power,
//                     ),
//                     _weatherInfoCard(
//                       title: "Max Temp",
//                       value: "${weather.maxTemperature.toStringAsFixed(2)}°C",
//                       icon: Icons.sunny,
//                     ),
//                     _weatherInfoCard(
//                       title: "Min Temp",
//                       value: "${weather.minTemperature.toStringAsFixed(2)}°C",
//                       icon: Icons.thermostat,
//                     ),
//                   ],
//                 ),
//                 const Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _weatherInfoCard(
//                       title: "Humidity",
//                       value: "${weather.humidity}%",
//                       icon: Icons.water_drop,
//                     ),
//                     _weatherInfoCard(
//                       title: "Pressure",
//                       value: "${weather.pressure} hPa",
//                       icon: Icons.compress,
//                     ),
//                     _weatherInfoCard(
//                       title: "Sea Level",
//                       value: "${weather.seaLevel} m",
//                       icon: Icons.waves,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _weatherInfoCard({
//     required String title,
//     required String value,
//     required IconData icon,
//   }) {
//     return Column(
//       children: [
//         Icon(
//           icon,
//           color: Colors.white,
//         ),
//         const SizedBox(height: 5),
//         Text(
//           value,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//           ),
//         ),
//       ],
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:intl/intl.dart';
// import 'TimezoneService.dart';
// import 'services.dart';
// import 'geocoding_service.dart';
// import 'weather_model.dart';
//
// class WeatherHome extends StatefulWidget {
//   const WeatherHome({Key? key}) : super(key: key);
//
//   @override
//   State<WeatherHome> createState() => _WeatherHomeState();
// }
//
// class _WeatherHomeState extends State<WeatherHome> {
//   late WeatherData weatherInfo;
//   bool isLoading = false;
//   String cityName = "City Name";
//
//   late Timer _timer;
//   DateTime currentTime = DateTime.now();
//   late String formattedDate;
//   late String formattedTime;
//
//   final TextEditingController _cityController = TextEditingController();
//
//   void myWeather(String inputCity) async {
//     setState(() {
//       isLoading = true; // Show progress bar
//     });
//
//     try {
//       final geocodingService = GeocodingServices();
//       final coordinates = await geocodingService.fetchLatLng(inputCity);
//
//       final lat = coordinates['lat']!;
//       final lon = coordinates['lng']!;
//
//       final weatherService = WeatherServices();
//       final weatherData = await weatherService.fetchWeatherByCoordinates(lat, lon);
//
//       final timezoneService = TimezoneService();
//       final timezoneData = await timezoneService.fetchTimezone(lat, lon);
//
//       final utcOffset = Duration(seconds: timezoneData['rawOffset']! + timezoneData['dstOffset']!);
//       final cityTime = DateTime.now().toUtc().add(utcOffset);
//
//       setState(() {
//         weatherInfo = weatherData;
//         cityName = weatherData.name;
//         currentTime = cityTime;
//         formattedDate = DateFormat('EEEE, d MMMM yyyy').format(cityTime);
//         formattedTime = DateFormat('hh:mm a').format(cityTime);
//         isLoading = false; // Hide progress bar
//       });
//     } catch (e) {
//       print("Error: $e");
//       setState(() {
//         isLoading = false; // Hide progress bar and show error
//         cityName = "Error loading weather data";
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     weatherInfo = WeatherData(
//       name: '',
//       temperature: Temperature(current: 0.0),
//       humidity: 0,
//       wind: Wind(speed: 0.0),
//       maxTemperature: 0,
//       minTemperature: 0,
//       pressure: 0,
//       seaLevel: 0,
//       weather: [],
//     );
//     formattedDate = DateFormat('EEEE, d MMMM yyyy').format(currentTime);
//     formattedTime = DateFormat('hh:mm a').format(currentTime);
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         currentTime = currentTime.add(const Duration(seconds: 1));
//         formattedTime = DateFormat('hh:mm a').format(currentTime);
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Weather App",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.deepPurple,
//       ),
//       backgroundColor: const Color(0xFF676BD0),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             children: [
//               TextField(
//                 controller: _cityController,
//                 decoration: InputDecoration(
//                   hintText: "Enter a city name",
//                   hintStyle: const TextStyle(color: Colors.white),
//                   filled: true,
//                   fillColor: Colors.deepPurple[300],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 style: const TextStyle(color: Colors.white),
//                 onSubmitted: (value) {
//                   myWeather(value);
//                 },
//               ),
//               const SizedBox(height: 20),
//               Center(
//                 child: isLoading
//                     ? const CircularProgressIndicator(
//                   color: Colors.white, // Show progress bar
//                 )
//                     : WeatherDetail(
//                   weather: weatherInfo,
//                   formattedDate: formattedDate,
//                   formattedTime: formattedTime,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class WeatherDetail extends StatelessWidget {
//   final WeatherData weather;
//   final String formattedDate;
//   final String formattedTime;
//
//   const WeatherDetail({
//     Key? key,
//     required this.weather,
//     required this.formattedDate,
//     required this.formattedTime,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 20),
//           child: Text(
//             weather.name,
//             style: const TextStyle(
//               fontSize: 25,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         Text(
//           "${weather.temperature.current.toStringAsFixed(2)}°C",
//           style: const TextStyle(
//             fontSize: 40,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         if (weather.weather.isNotEmpty)
//           Text(
//             weather.weather[0].main,
//             style: const TextStyle(
//               fontSize: 20,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         const SizedBox(height: 30),
//         Text(
//           formattedDate,
//           style: const TextStyle(
//             fontSize: 18,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           formattedTime,
//           style: const TextStyle(
//             fontSize: 18,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 30),
//         Container(
//           height: 250,
//           decoration: BoxDecoration(
//             color: Colors.deepPurple,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _weatherInfoCard(
//                       title: "Wind",
//                       value: "${weather.wind.speed} km/h",
//                       icon: Icons.wind_power,
//                     ),
//                     _weatherInfoCard(
//                       title: "Max",
//                       value: "${weather.maxTemperature.toStringAsFixed(2)}°C",
//                       icon: Icons.sunny,
//                     ),
//                     _weatherInfoCard(
//                       title: "Min",
//                       value: "${weather.minTemperature.toStringAsFixed(2)}°C",
//                       icon: Icons.thermostat,
//                     ),
//                   ],
//                 ),
//                 const Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _weatherInfoCard(
//                       title: "Humidity",
//                       value: "${weather.humidity}%",
//                       icon: Icons.water_drop,
//                     ),
//                     _weatherInfoCard(
//                       title: "Pressure",
//                       value: "${weather.pressure} hPa",
//                       icon: Icons.compress,
//                     ),
//                     _weatherInfoCard(
//                       title: "Sea Level",
//                       value: "${weather.seaLevel} m",
//                       icon: Icons.waves,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _weatherInfoCard({
//     required String title,
//     required String value,
//     required IconData icon,
//   }) {
//     return Column(
//       children: [
//         Icon(
//           icon,
//           color: Colors.white,
//         ),
//         const SizedBox(height: 5),
//         Text(
//           value,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//           ),
//         ),
//       ],
//     );
//   }
// }