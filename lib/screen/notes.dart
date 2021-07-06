import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notepad_laravel_api/main.dart';
import 'package:notepad_laravel_api/model/base/api_response.dart';
import 'package:notepad_laravel_api/model/note.dart';
import 'package:notepad_laravel_api/services/note_service.dart';
import 'package:notepad_laravel_api/shared_preferences/shared.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  //values
  bool _loading = true;

  //list user notes
  List<dynamic> list_user_notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('نوشته های من'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: list_user_notes.length,
              itemBuilder: (context, index) {
                Note note = Note.formJson(list_user_notes[index]);
                return Text(note.content.toString());
              }),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('user name')),
            ListTile(
              title: Text('خروج'),
              onTap: (){
                removeToken();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Home()), (route) => false)
              },
            )
          ],
        ),
      ),
    );
  }

  void _loadUserNotes() async {
    APiResponse user_notes_response = await getUserNotes();
    setState(() {
      _loading = false;
    });
    if (user_notes_response.error == null) {
      setState(() {
        list_user_notes = jsonDecode(user_notes_response.data.toString());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(user_notes_response.error.toString()),
      ));
    }
  }
}
