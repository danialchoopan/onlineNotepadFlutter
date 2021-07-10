import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:notepad_laravel_api/model/base/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:notepad_laravel_api/model/user.dart';
import 'package:notepad_laravel_api/services/EndPoint.dart';

//register user
Future<APiResponse> registerUser(
    String name, String email, String password) async {
  APiResponse api_response = APiResponse();
  try {
    final http_response = await http.post(Uri.parse(user_register), headers: {
      'Accept': 'application/json',
    }, body: {
      'name': name,
      'email': email,
      'password': password
    }).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('time out connection');
      },
    );
    if (http_response.statusCode == 200) {
      api_response.data = User.fromJson(jsonDecode(http_response.body));
      // api_response.data = http_response.body;
    } else {
      api_response.error = 'پست الکترونیک شما تکراری است';
    }
  } on TimeoutException {
    api_response.error = 'مشکلی پیش آمده است لطفا دوباره امتحان کنید.';
  }
  return api_response;
}

//login user
Future<APiResponse> loginUser(String email, String password) async {
APiResponse api_response = APiResponse();
  try {
    final http_response_login = await http.post(Uri.parse(user_login),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password}).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('time out connection');
      },
    );
    if (http_response_login.statusCode == 200) {
      api_response.data = User.fromJson(jsonDecode(http_response_login.body));
    } else {
      api_response.error = 'پست الکترونیک شما یا رمزعبور شما اشتباه است';
    }
  } on TimeoutException {
    api_response.error = 'مشکلی پیش آمده است لطفا دوباره امتحان کنید.';
  }
  return api_response;
}
