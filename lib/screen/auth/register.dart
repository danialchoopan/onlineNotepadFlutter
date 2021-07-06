import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notepad_laravel_api/model/base/api_response.dart';
import 'package:notepad_laravel_api/model/user.dart';
import 'package:notepad_laravel_api/screen/notes.dart';
import 'package:notepad_laravel_api/services/user_service.dart';
import 'package:notepad_laravel_api/shared_preferences/shared.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //values
  bool _loading = false;

  //form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //text filed
  final txt_name = TextEditingController();
  final txt_email = TextEditingController();
  final txt_password = TextEditingController();
  final txt_password_re = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('نام نویسی'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: txt_name,
                      validator: (val) =>
                          val!.isEmpty ? 'نام اجباری است' : null,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10), hintText: 'نام'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: txt_email,
                      validator: (val) =>
                          val!.isEmpty ? 'پست الکترونیک اجباری است' : null,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: 'پست الکترونیک'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: txt_password,
                      validator: (val) =>
                          val!.isEmpty ? 'رمزعبور اجباری است' : null,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: 'رمزعبور'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: txt_password_re,
                      validator: (val) => val != txt_password.text
                          ? 'تکرار رمزعبور شما با رمزعبور فعلی شما برابر نیست'
                          : null,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: 'تکرار رمزعبور'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _registerUser();
                          setState(() {
                            _loading = true;
                          });
                        }
                      },
                      child: Text('نام نویسی'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  //register user
  void _registerUser() async {
    APiResponse user_response =
        await registerUser(txt_name.text, txt_email.text, txt_password.text);
    setState(() {
      _loading = false;
    });
    if (user_response.error == null) {
      final user = (user_response.data as User);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('شما با موفقیت نام نویسی شده اید')));
      setUserToken(user.token.toString());
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Notes()), (route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${user_response.error}')));
    }
  }
}
