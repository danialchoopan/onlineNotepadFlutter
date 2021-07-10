import 'package:flutter/material.dart';
import 'package:notepad_laravel_api/model/base/api_response.dart';
import 'package:notepad_laravel_api/model/user.dart';
import 'package:notepad_laravel_api/screen/notes/notes.dart';
import 'package:notepad_laravel_api/services/user_service.dart';
import 'package:notepad_laravel_api/shared_preferences/shared.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //values
  bool _loading = false;

  //form
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  //text controller
  final txt_email = TextEditingController();
  final txt_password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ورود'),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formkey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    TextFormField(
                      controller: txt_email,
                      validator: (val) =>
                          val!.isEmpty ? 'پست الکترونیک اجباری است' : null,
                      decoration: InputDecoration(hintText: 'پست الکترونیک'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: txt_password,
                      validator: (val) =>
                          val!.isEmpty ? 'رمزعبور اجباری است' : null,
                      decoration: InputDecoration(hintText: 'رمزعبور'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              _loading = true;
                            });
                            _loginUser();
                          }
                        },
                        child: Text('ورود'))
                  ],
                ),
              ),
            ),
    );
  }

  void _loginUser() async {
    APiResponse response_login =
        await loginUser(txt_email.text, txt_password.text);
    setState(() {
      _loading = false;
    });
    if (response_login.error == null) {
      final userData = (response_login.data as User);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('شما با موفقیت وارد شده اید'),
      ));
      setUserToken(userData.token.toString());
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Notes()), (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response_login.error.toString()),
      ));
    }
  }
}
