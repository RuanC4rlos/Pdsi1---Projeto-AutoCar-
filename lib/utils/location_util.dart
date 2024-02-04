// ignore: constant_identifier_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: constant_identifier_names
const GOOGLE_API_KEY = 
class LocationUtil {
  static String generateLocationPreviewImage({
    required double latitude,
    required double longitude,
  }) {
    return  }

  static Future<String> getAddressFrom(LatLng position) async {
    final url =
        final response = await http.get(Uri.parse(url));
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
