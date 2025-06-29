import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:notes/Data/DBHelper.dart';
import 'package:notes/Model/Note_model.dart';

class textFieldProvider with ChangeNotifier{
    List <Note> _notes=[];
    List <Note> get notes => _notes;

    ///get all notes from db
    Future <void> getAllNotes() async{
      final data = await DBHelper.getInctance.getAllNotes();
      Note convertToNote(Map<String , dynamic> e){
        return Note.fromMap(e);
      }
      _notes=data.map(convertToNote).toList();
      notifyListeners();
    }

    Future <void> addNote(String title, String desc) async{
     await DBHelper.getInctance.addNote(mTitle: title, mDesc: desc);
     await getAllNotes();
     notifyListeners();
    }
    Future <void> updateNote(String title, String desc,int sno) async{
      await DBHelper.getInctance.updateNote(mTitle: title, mDesc: desc, sno: sno);
      await getAllNotes();
      notifyListeners();
    }
    Future <void> deleteNote(int sno)async{
      await DBHelper.getInctance.deleteNote(sno: sno);
      await getAllNotes();
      notifyListeners();
    }

}