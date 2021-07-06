import 'dart:convert';

import 'package:notepad_laravel_api/model/base/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:notepad_laravel_api/services/EndPoint.dart';
import 'package:notepad_laravel_api/shared_preferences/shared.dart';

Future<APiResponse> getUserNotes() async {
  APiResponse api_response = APiResponse();
  String token = await getUserToken();
  final response_user_notes = await http.get(Uri.parse(user_notes), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });
  if (response_user_notes.statusCode == 200) {
    api_response.data = response_user_notes.body.toString();
  } else {
    api_response.error = 'مشکلی پیش آمده است لطفا بعدا امتحان کنید';
  }
  return api_response;
}
