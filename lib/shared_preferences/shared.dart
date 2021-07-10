import 'package:shared_preferences/shared_preferences.dart';

//get user token
Future<String> getUserToken() async {
  final shared = await SharedPreferences.getInstance();
  String user_token = shared.getString('user_token') ?? '';
  return user_token;
}

//get user name
Future<String> getUserName() async {
  final shared = await SharedPreferences.getInstance();
  String user_name = shared.getString('user_name') ?? '';
  return user_name;
}

//set and remove user token and user name
Future<void> setUserToken(String userToken) async {
  final shared = await SharedPreferences.getInstance();
  await shared.setString('user_token', userToken);
}

Future<void> setUserName(String userName) async {
  final shared = await SharedPreferences.getInstance();
  await shared.setString('user_name', userName);
}

Future<void> removeToken() async {
  final shared = await SharedPreferences.getInstance();
  await shared.remove('user_token');
  await shared.remove('user_name');
}
