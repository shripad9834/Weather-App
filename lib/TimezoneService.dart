// class TimezoneService {
//   Future<Map<String, int>> fetchTimezone(double lat, double lon) async {
//     return {"rawOffset": 3600, "dstOffset": 0};
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;

class TimezoneService {
  // Replace with your actual API key from Google Time Zone API
  final String apiKey = 'YOUR_GOOGLE_TIMEZONE_API_KEY';

  Future<Map<String, int>> fetchTimezone(double lat, double lon) async {
    // Construct the API request URL
    final String url =
        'https://maps.googleapis.com/maps/api/timezone/json?location=$lat,$lon&timestamp=${DateTime.now().millisecondsSinceEpoch ~/ 1000}&key=$apiKey';

    // Send the HTTP request
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the request is successful, parse the JSON response
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == 'OK') {
        // Extract the rawOffset and dstOffset from the response
        return {
          'rawOffset': data['rawOffset'],
          'dstOffset': data['dstOffset'],
        };
      } else {
        throw Exception('Failed to load timezone data');
      }
    } else {
      throw Exception('Failed to fetch timezone data from API');
    }
  }
}
