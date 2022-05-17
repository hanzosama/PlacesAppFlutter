import '../security/secrets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationHelper {
  static String generateLocationPreviewImage(
      {double latitude, double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_BASE_APY_KEY';
  }

  static Future<String> getPlaceAddress(
      {double latitude, double longitude}) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_BASE_APY_KEY');
    final response = await http.get(url);

    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
