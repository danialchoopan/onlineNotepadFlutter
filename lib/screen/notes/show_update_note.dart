import 'package:flutter/material.dart';
import 'package:notepad_laravel_api/model/base/api_response.dart';
import 'package:notepad_laravel_api/model/note.dart';
import 'package:notepad_laravel_api/services/note_service.dart';

class ShowUpdateNote extends StatefulWidget {
  final Note noteUser;

  const ShowUpdateNote(this.noteUser);

  @override
  _ShowUpdateNoteState createState() => _ShowUpdateNoteState();
}

class _ShowUpdateNoteState extends State<ShowUpdateNote> {
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
        title: Text('بروزرسانی نوشته'),
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
            _updateUserNote();
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _txt_content.text = widget.noteUser.content!;
  }

  void _updateUserNote() async {
    APiResponse response_save_note_user =
        await updateUserNote(widget.noteUser.id.toString(), _txt_content.text);
    setState(() {
      _loading = false;
    });
    if (response_save_note_user.error == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('نوشته شما با موفقیت بروز شد')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response_save_note_user.error.toString())));
    }
  }
}
