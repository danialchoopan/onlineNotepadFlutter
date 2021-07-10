import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notepad_laravel_api/main.dart';
import 'package:notepad_laravel_api/model/base/api_response.dart';
import 'package:notepad_laravel_api/model/note.dart';
import 'package:notepad_laravel_api/screen/notes/add_note.dart';
import 'package:notepad_laravel_api/screen/notes/show_update_note.dart';
import 'package:notepad_laravel_api/services/note_service.dart';
import 'package:notepad_laravel_api/shared_preferences/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  //values
  bool _loading = true;
  String _username = '';

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
          : list_user_notes.length == 0
              ? Center(
                  child: Text('نوشته ای جهت نمایش وجود ندارد'),
                )
              : RefreshIndicator(
                  onRefresh: () {
                    return _loadUserNotes();
                  },
                  child: ListView.builder(
                      itemCount: list_user_notes.length,
                      itemBuilder: (context, index) {
                        Note note = Note.formJson(list_user_notes[index]);
                        String textShowInList = '';
                        if (note.content!.length > 20) {
                          textShowInList =
                              note.content!.substring(1, 20) + " ...";
                        } else {
                          textShowInList = note.content! + ' ...';
                        }
                        return Container(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              ListTile(
                                title: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ShowUpdateNote(note)));
                                    },
                                    child: Text('$textShowInList')),
                                trailing: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Center(
                                                child: Text('پاک کردن نوشته'),
                                              ),
                                              content: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      'آیا می خواهید نوشته را حذف کنید',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      _deleteNote(
                                                          note.id.toString());
                                                      _loadUserNotes();
                                                    },
                                                    child: Text('حذف')),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('بی خیال ')),
                                              ],
                                            );
                                          });
                                    },
                                    child: Icon(Icons.delete)),
                              ),
                              Divider()
                            ],
                          ),
                        );
                      }),
                ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.grey,
              ),
              accountName: Text('$_username'),
              accountEmail: Text(' '),
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('خروج'),
                onTap: () {
                  removeToken();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Home()),
                      (route) => false);
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _open_add_note();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserNotes();
  }

  Future<void> _loadUserNotes() async {
    APiResponse user_notes_response = await getUserNotes();
    setState(() {
      _loading = false;
    });
    if (user_notes_response.error == null) {
      Map<String, dynamic> map =
          jsonDecode(user_notes_response.data.toString());
      setState(() {
        list_user_notes = map['notes'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(user_notes_response.error.toString()),
      ));
    }
  }

  //open add note page
  void _open_add_note() async {
    final result_add_note = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddNote()));
    if (result_add_note == "note_added") {
      setState(() {
        _loading = true;
      });
      _loadUserNotes();
    }
  }

  Future<void> _deleteNote(String note_id) async {
    APiResponse response_delete = await deleteUserNote(note_id);
    setState(() {
      _loading = false;
    });
    if (response_delete.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('نوشته مورد نظر شما حدف شد'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response_delete.error.toString()),
      ));
    }
  }
}
