// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class GeocodingServices {
//   final String geocodingApiKey = "7f01d3b43dc1e81470ff55a6562a1b35";
//
//   Future<Map<String, double>> fetchLatLng(String location) async {
//     final url =
//         "http://api.positionstack.com/v1/forward?access_key=$geocodingApiKey&query=$location";
//
//     print("Geocoding API URL: $url"); // Debugging log
//
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final json = jsonDecode(response.body);
//       if (json['data'] != null && json['data'].isNotEmpty) {
//         final data = json['data'][0];
//         return {
//           'lat': data['latitude'] ?? 0.0,
//           'lng': data['longitude'] ?? 0.0,
//         };
//       } else {
//         throw Exception("No results found for the location");
//       }
//     } else {
//       print("Geocoding API Response: ${response.body}"); // Debug response
//       throw Exception("Failed to fetch coordinates");
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingServices {
  final String geocodingApiKey = "7f01d3b43dc1e81470ff55a6562a1b35";

  Future<Map<String, double>> fetchLatLng(String location) async {
    final url =
        "http://api.positionstack.com/v1/forward?access_key=$geocodingApiKey&query=$location&limit=1";

    print("Geocoding API URL: $url"); // Debugging log

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['data'] != null && json['data'].isNotEmpty) {
        final data = json['data'][0];
        return {
          'lat': data['latitude'] ?? 0.0,
          'lng': data['longitude'] ?? 0.0,
        };
      } else {
        throw Exception("No results found for the location");
      }
    } else {
      print("Geocoding API Response: ${response.body}"); // Debug response
      throw Exception("Failed to fetch coordinates");
    }
  }
}

