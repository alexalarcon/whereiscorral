import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'authentication.dart';

//final apiUrl = 'https://cogespar-dev.altostratus.es/api';
const apiUrl = 'https://sercide-cloudrun-go-sugxd6wixq-ew.a.run.app';

class DataService {
  static Future<Response> postEntity(String entityName, data) async {
    final token = await Authentication.getTokenId();
    Authentication.customClaims();

    var url = Uri.parse('$apiUrl/$entityName');
    final response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data));
    return response;
  }
}
