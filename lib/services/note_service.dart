import 'dart:async';
import 'dart:convert';

import 'package:notepad_laravel_api/model/base/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:notepad_laravel_api/services/EndPoint.dart';
import 'package:notepad_laravel_api/shared_preferences/shared.dart';

//get all user notes
Future<APiResponse> getUserNotes() async {
  APiResponse api_response = APiResponse();
  try {
    String token = await getUserToken();
    final response_user_notes = await http.get(Uri.parse(user_notes), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('time out connection');
      },
    );
    if (response_user_notes.statusCode == 200) {
      api_response.data = response_user_notes.body.toString();
    } else {
      api_response.error = 'مشکلی پیش آمده است لطفا بعدا امتحان کنید';
    }
  } on TimeoutException {
    api_response.error = 'مشکلی پیش آمده است لطفا بعدا امتحان کنید';
  }
  return api_response;
}

//add user note
Future<APiResponse> addUserNote(String content) async {
  APiResponse api_response = APiResponse();
  try {
    String token = await getUserToken();
    final response_user_note = await http.post(Uri.parse(user_notes), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'content': content
    }).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('time out connection');
      },
    );
    if (response_user_note.statusCode == 200) {
      api_response.data = response_user_note.body.toString();
    } else {
      api_response.error = 'مشکلی پیش آمده است . نوشته شما ذخیره نشد';
    }
  } on TimeoutException {
    api_response.error = 'مشکلی پیش آمده است لطفا بعدا امتحان کنید';
  }
  return api_response;
}

//delete user note
Future<APiResponse> deleteUserNote(String note_id) async {
  APiResponse api_response = APiResponse();
  try {
    String token = await getUserToken();
    final response_user_note = await http
        .delete(Uri.parse(user_notes + '/$note_id'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('time out connection');
      },
    );
    if (response_user_note.statusCode == 200) {
      api_response.data = response_user_note.body.toString();
    } else {
      api_response.error = 'مشکلی پیش آمده است . نوشته شما ذخیره نشد';
    }
  } on TimeoutException {
    api_response.error = 'مشکلی پیش آمده است لطفا بعدا امتحان کنید';
  }
  return api_response;
}

//update note

//add user note
Future<APiResponse> updateUserNote(String note_id, String content) async {
  APiResponse api_response = APiResponse();
  try {
    String token = await getUserToken();
    final response_user_note = await http
        .post(Uri.parse(user_note_update + '/$note_id'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'content': "dasda"
    }).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('time out connection');
      },
    );
    print(response_user_note.body);
    if (response_user_note.statusCode == 200) {
      api_response.data = response_user_note.body.toString();
    } else {
      api_response.error = 'مشکلی پیش آمده است . نوشته شما بروز نشد';
    }
  } on TimeoutException {
    api_response.error = 'مشکلی پیش آمده است لطفا بعدا امتحان کنید';
  }
  return api_response;
}
