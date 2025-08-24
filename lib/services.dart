import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wheather/weather_model.dart';

class WeatherServices{
  fetchWeather() async{
    final response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=17.6599&lon=75.9064&appid=a4c4e53a4ebd2a2bab1f693e621d89b4"),);
    try{
      if(response.statusCode == 200){
        var json = jsonDecode(response.body);
        return WeatherData.fromJson(json);
      }else{
        throw Exception("Failed to load weather data");
      }
    }catch(e){
      print(e.toString());
    }
  }
}

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'weather_model.dart';
//
// class WeatherServices {
//   Future<WeatherData> fetchWeatherByCoordinates(double lat, double lon) async {
//     final response = await http.get(
//       Uri.parse(
//           "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=YOUR_OPENWEATHER_API_KEY"),
//     );
//     if (response.statusCode == 200) {
//       var json = jsonDecode(response.body);
//       return WeatherData.fromJson(json);
//     } else {
//       throw Exception("Failed to load weather data");
//     }
//   }
// }
//
// class GeocodingServices {
//   Future<Map<String, double>> fetchLatLng(String location) async {
//     const String apiKey = '7f01d3b43dc1e81470ff55a6562a1b35';
//     final response = await http.get(
//       Uri.parse(
//           'http://api.positionstack.com/v1/forward?access_key=$apiKey&query=$location'),
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['data'].isNotEmpty) {
//         final lat = data['data'][0]['latitude'];
//         final lng = data['data'][0]['longitude'];
//         return {'lat': lat, 'lng': lng};
//       } else {
//         throw Exception('Location not found');
//       }
//     } else {
//       throw Exception('Failed to fetch geocoding data');
//     }
//   }
// }

//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:wheather/weather_model.dart';
//
// class WeatherServices {
//   final String weatherApiKey = "a4c4e53a4ebd2a2bab1f693e621d89b4";
//
//   Future<WeatherData> fetchWeatherByCoordinates(double lat, double lon) async {
//     final url =
//         "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$weatherApiKey";
//
//     print("Weather API URL: $url"); // Debugging log
//
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final json = jsonDecode(response.body);
//       return WeatherData.fromJson(json);
//     } else {
//       print("Weather API Response: ${response.body}"); // Debug response
//       throw Exception("Failed to load weather data");
//     }
//   }
// }
