import 'package:flutter/material.dart';
import 'package:notepad_laravel_api/model/base/api_response.dart';
import 'package:notepad_laravel_api/services/note_service.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  //values
  bool _loading = false;

  //form

  GlobalKey<FormState> _from_key = GlobalKey<FormState>();

  //text controller
  final _txt_content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('افزون نوشته'),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _from_key,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _txt_content,
                validator: (val) =>
                    val!.isEmpty ? 'نوشته فیلد اجباری است' : null,
                decoration: InputDecoration(hintText: 'نوشته '),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save_outlined),
        onPressed: () {
          if (_from_key.currentState!.validate()) {
            setState(() {
              _loading = true;
            });
            _saveUserNote();
          }
        },
      ),
    );
  }

  void _saveUserNote() async {
    APiResponse response_save_note_user = await addUserNote(_txt_content.text);
    setState(() {
      _loading = false;
    });
    if (response_save_note_user.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('نوشته شما با موفقیت ذخیره شد')));
      Navigator.of(context).pop('note_added');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response_save_note_user.error.toString())));
    }
  }
}
