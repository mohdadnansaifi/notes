
import 'package:flutter/material.dart';
import 'package:notes/Data/DBHelper.dart';

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  ///controller
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  String errorMsg = "";
  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInctance;
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          title: Text("Notes"),
          centerTitle: true,
           actions: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Image.asset("assets/images/icon.png",width: 30,height: 30,),
             ),
           ],
          backgroundColor: Color(0xfff5d7fa)),

      ///all notes viewed here
      body:
      allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(20)
                        // bottomLeft: Radius.circular(20.0),
                        // topRight: Radius.circular(20.0))
                        ),
                    child: ListTile(
                      leading: Text(
                        "${index + 1}",
                        style: TextStyle(fontSize: 15),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            allNotes[index][DBHelper.COLUMN_NOTE_TITLE],
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          )
                        ],
                      ),
                      subtitle: Text(
                        allNotes[index][DBHelper.COLUMN_NOTE_DESC],
                        style: TextStyle(fontSize: 15),
                      ),
                      trailing: SizedBox(
                        width: 50,
                        child: Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  _showUpdateBottomSheet(
                                      allNotes[index][DBHelper.COLUMN_NOTE_SNO],
                                      allNotes[index]
                                          [DBHelper.COLUMN_NOTE_TITLE],
                                      allNotes[index]
                                          [DBHelper.COLUMN_NOTE_DESC]);
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.blueGrey,
                                )),
                            InkWell(
                                onTap: () async {
                                  _showDeleteConfirmationDialog(allNotes[index]
                                      [DBHelper.COLUMN_NOTE_SNO]);
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.blueGrey,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })
          : Center(
              child: Text("No Notes yet!!"),
            ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30,right: 10),
        child: FloatingActionButton(
          onPressed: () async {
            _showAddBottomSheet();
          },
          child: Image.asset("assets/images/icon.png",height: 40,width: 40,),
        ),
      ),
    );
  }

  void _showAddBottomSheet() {
    titleController.clear();
    descController.clear();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(


            child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom
                ),
                child: getBottomSheetWidget()),
          );
        });
  }

  void _showUpdateBottomSheet(int sno, String title, String desc) {
    titleController.text = title;
    descController.text = desc;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom
                ),
                child: getBottomSheetWidget(isUpdate: true, Sno: sno)),
          );
        });
  }

  void _showDeleteConfirmationDialog(int sno) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete Note"),
            content: Text("Are you sure you want to delete this note?"),
            actions: [

              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    bool isDeleted = await dbRef!.deleteNote(sno: sno);

                    if (isDeleted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Note deleted successfully!")),
                      );
                      getNotes();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to delete note!!")),
                      );
                    }
                  },
                  child: Text("Delete")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
            ],
          );
        });
  }


  Widget getBottomSheetWidget({bool isUpdate = false, int Sno = 0}) {
    return SingleChildScrollView(
      child: Container(
      
        padding: EdgeInsets.all(11),
        width: double.infinity,
        child: Column(
           mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isUpdate ? "Update Note" : "Add Note",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 21,
            ),
            TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Enter Note title here",
                  label: Text("Title *"),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                )),
            SizedBox(
              height: 11,
            ),
            TextField(
                controller: descController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Enter Note here",
                  label: Text("Note *"),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                )),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11))),
                      onPressed: () async {
                        // Navigator.pop(context);
                        var title = titleController.text;
                        var desc = descController.text;
                        if (title.isNotEmpty && desc.isNotEmpty) {
                          bool check = isUpdate
                              ? await dbRef!.updateNote(
                                  mTitle: title, mDesc: desc, sno: Sno)
                              : await dbRef!.addNote(mTitle: title, mDesc: desc);
                          if (check) {
                            getNotes();
                          }
      
                          titleController.clear();
                          descController.clear();
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Please fill all the required blanks!!")));
                        }
      
                      },
                      child: Text(isUpdate ? "Update Note" : "Add Note")),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"))),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text("$errorMsg"),
          ],
        ),
      ),
    );
  }
}
