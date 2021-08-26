import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helper/dataBase_helper.dart';
import '../helper/note_Class.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  String appBarTitle;
  Note note;
  DatabaseHelper helper = DatabaseHelper();
  static var _priorities = ['High', 'Low'];
  // ------
  NoteDetailState(this.note, this.appBarTitle);
  // ------
//  TODO: text controllers
  TextEditingController titleController = new TextEditingController();
  TextEditingController desecriptionController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    desecriptionController.text = note.description;

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        backgroundColor: Color(0xffCACCCE),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    const Color(0xFF00CCFF),
                    const Color(0xFF3366FF),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          title: Text(
            appBarTitle,
            style: GoogleFonts.nunito(
              color: Color(0xffFCF8EC),
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 15.0,
                    bottom: 5.0,
                  ),
                  //dropdown menu
                  child: new ListTile(
                    leading: const Icon(Icons.low_priority_rounded),
                    title: DropdownButton(
                        items: _priorities.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(
                              dropDownStringItem,
                              style: GoogleFonts.nunito(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          );
                        }).toList(),
                        value: getPriorityAsString(note.priority),
                        onChanged: (valueSelectedByUser) {
                          setState(() {
                            updatePriorityAsInt(valueSelectedByUser);
                          });
                        }),
                  ),
                ),
                // Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                  child: TextField(
                    minLines: 1,
                    maxLines: 3,
                    controller: titleController,
                    style: GoogleFonts.nunito(),
                    onChanged: (value) {
                      updateTitle();
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: GoogleFonts.nunito(color: Colors.black),
                      icon: Icon(Icons.title),
                    ),
                  ),
                ),

                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                  child: TextField(
                    minLines: 3,
                    maxLines: 10,
                    controller: desecriptionController,
                    style: GoogleFonts.nunito(),
                    onChanged: (value) {
                      updatedesecription();
                    },
                    decoration: InputDecoration(
                      labelText: 'Details',
                      labelStyle: GoogleFonts.nunito(),
                      icon: Icon(Icons.message_rounded),
                    ),
                  ),
                ),

                // Fourth Element
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          textColor: Colors.black,
                          color: Colors.greenAccent,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Save',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                            ),
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          textColor: Colors.black,
                          color: Colors.redAccent,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Delete',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                            ),
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              _delete();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//  TODO: Text controllers methos to assign
  void updateTitle() {
    note.title = titleController.text;
  }

  void updatedesecription() {
    note.description = desecriptionController.text;
  }

// TODO: alert controller
  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        title,
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  // TODO: saving and deleting the note by clicking its a method
  void _save() async {
    moveToLastScreen();
    int result;
    //.addPattern('dd-MM-yyyy')
    // ('dd-MM-yyyy(h:m)')
    note.date = DateFormat('dd-MM-yyyy\n').add_jm().format(DateTime.now());
    if (note.id != null) {
      result = await helper.updatetNote(note);
    } else {
      result = await helper.insertNote(note);
    }
    if (result != 0) {
      _showAlertDialog('Status', 'Saved Successfuly!');
    } else {
      _showAlertDialog('Status', 'Something went Bad!');
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // TODO: delete method
  void _delete() async {
    moveToLastScreen();
    if (note.id == null) {
      _showAlertDialog('Status', "Add A Note");
      return;
    }
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Deleted Successfuly!');
    } else {
      _showAlertDialog('Status', 'Something went Bad on Deleting!');
    }
  }

  // TODO: Priority method
  //string to int for database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  //  int to string to user in ui
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];

        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }
}
