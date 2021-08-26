import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'noteDetails.dart';
import '../helper/dataBase_helper.dart';
import '../helper/note_Class.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:gradient_widgets/gradient_widgets.dart';
// import 'package:glass_kit/glass_kit.dart';

class HomePage extends StatefulWidget {
  // const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ------------------------------------------------------
  // creating object of classes to reduce code
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<Note> noteList;
  int count = 0; //to count how many dabase are made
  // -------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      // F1F3F6
      backgroundColor: Color(0xffF1F3F6),
      appBar: AppBar(
        title: Text(
          "Notes",
          style: GoogleFonts.nunito(
            color: Color(0xffFCF8EC),
            fontWeight: FontWeight.w700,
          ),
        ),
        // titleSpacing: 6,
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
      ),
      // Color(0xffFCF8EC),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: () {
          navigateToDetails(Note('', '', 2), 'note');
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  // ----------------------------------------------------
  //  TODO: Button to navigate to anotther page for adding the details
  void navigateToDetails(Note note, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return NoteDetail(note, title);
        },
      ),
    );
    if (result == true) {
      updateListView();
    }
  }

  // TODO: update view
  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initalizerdatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return GradientCard(
          // color: Colors.transparent,
          // color: Colors.deepPurple,
          gradient: Gradients.blush,
          // shadowColor: Colors.black,

          // elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: ListTile(
            title: Text(
              this.noteList[position].title,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: Text(
              this.noteList[position].date,
              style: GoogleFonts.nunito(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              this.noteList[position].description,
              style: GoogleFonts.nunito(
                color: Colors.black87,
              ),
            ),
            trailing: GestureDetector(
              child: Icon(
                Icons.edit,
                color: Colors.black,
              ),
              onTap: () =>
                  navigateToDetails(this.noteList[position], 'edit To Do'),
            ),
          ),
        );
      },
    );
  }

  // ----------------------------------------------------
}
