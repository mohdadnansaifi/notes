import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/Data/DBHelper.dart';
import 'package:notes/Pages/taskPage.dart';
import 'package:notes/Provider/textFieldProvider.dart';
import 'package:notes/Provider/themeProvider.dart';
import 'package:notes/Model/Note_model.dart';
import 'package:provider/provider.dart';

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  ///controller
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  Note? isExisting;
  @override
  bool _isInit = true;
  @override

  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<textFieldProvider>(context, listen: false).getAllNotes();
      _isInit = false;
    }
  }


  Widget build(BuildContext context) {
    final themeChanger = Provider.of<themeProvider>(context,listen: false);
    print("Build");
    return Scaffold(
      backgroundColor: themeChanger.isDark ? Colors.black : Color(0xFFe6e6ff),
      appBar: AppBar(
        backgroundColor: themeChanger.isDark ? Colors.black:Color(0xFFe6e6ff),
        title: Text("Notes",
            style:
                GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w600,color: themeChanger.isDark?Colors.white:Colors.black)),
        centerTitle: true,
        // backgroundColor: Colors.teal,
        actions: [
          IconButton(
              onPressed: () {
                themeChanger.setTheme(!themeChanger.isDark);
              },
              icon: Icon(
                themeChanger.isDark ? Icons.dark_mode : Icons.light_mode,
                color: themeChanger.isDark ? Colors.white : Colors.black,
              ))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // ensures DrawerHeader touches full width
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 28,
                    child: Icon(Icons.task, size: 30, color: Colors.purple),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome!",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "Tap to explore tasks",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.check_circle_outline, color: Colors.deepPurple),
              title: Text(
                "TaskFlow",
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => taskPage()),
                );
              },
            ),
            Divider(thickness: 1),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text(
                "Logout",
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context); // add your logout logic here if needed
              },
            ),
          ],
        ),
      ),

      body:

      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(themeChanger.isDark? 0xFF262626:0xFFccccff),
              ),

              height: 270,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25,right: 25,top: 15),
                    child: TextField(
                      controller: titleController,
                      style: TextStyle(color: themeChanger.isDark? Colors.white:Colors.black),
                      decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle:TextStyle(color: themeChanger.isDark? Colors.white:Colors.black),
                          hintText: "Enter title",
                          hintStyle: TextStyle(color: themeChanger.isDark? Colors.white54:Colors.black),
                          filled: true,
                          fillColor: themeChanger.isDark ? Colors.black:Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25,left: 25),
                    child: TextField(
                      controller: descController,
                      style: TextStyle(color: themeChanger.isDark? Colors.white:Colors.black),
                      maxLines: 3,
                      decoration: InputDecoration(
                          labelText: "Note",
                          labelStyle:TextStyle(color: themeChanger.isDark? Colors.white:Colors.black),
                          hintText: "Write Note Here!",
                          hintStyle: TextStyle(color: themeChanger.isDark? Colors.white54:Colors.black),
                          filled: true,
                          fillColor: themeChanger.isDark ? Colors.black:Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            titleController.clear();
                            descController.clear();
                          },
                          child: Text("Cancel",style:TextStyle(fontSize: 20,color:themeChanger.isDark?Colors.white:Colors.black))),
                      ElevatedButton(
                          onPressed: () {
                            final title = titleController.text.trim();
                            final desc = descController.text.trim();
                            if(title.isEmpty || desc.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Please enter both title and note!",style: TextStyle(color: Colors.white,fontSize: 17),),
                                      backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                    margin: EdgeInsets.all(20),
                                  ),
                                  );
                              return;
                            }
                            isExisting == null
                                ? Provider.of<textFieldProvider>(context, listen: false)
                                .addNote(title, desc)
                                : Provider.of<textFieldProvider>(context, listen: false)
                                .updateNote(title, desc, isExisting!.sno!);
                            titleController.clear();
                            descController.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8080ff),
                            minimumSize: Size(120, 50),
                            foregroundColor: Colors.white
                          ),
                          child: Text("Save",style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w600),)),

                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: noteList(
              ondelete: (noteId){
                showDeleteDialog(noteId);
              },
              onEdit: (note){
                openNoteForm(context, isExisting:note);
              }
            )
          ),
        ],
      ),
    );
  }

  Future<void> showDeleteDialog(int noteId)async{
    final themeChanger =Provider.of<themeProvider>(context,listen: false);
    await showDialog(context: context, builder: (context)=>AlertDialog(

      title: Text("Delete Note",style: TextStyle(color: themeChanger.isDark?Colors.white:Colors.black),),
      content: Text("Are you sure you want to delete this note?",style: TextStyle(color: themeChanger.isDark?Colors.white:Colors.black),),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Cancel",style: TextStyle(color: themeChanger.isDark?Colors.white:Colors.black),)),
        ElevatedButton(
            onPressed: ()async{
          await Provider.of<textFieldProvider>(context,
              listen: false)
              .deleteNote(noteId);
          Navigator.pop(context);
        },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8080ff),
              foregroundColor: Colors.white
            ),
            child: Text("Delete",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),))
      ],
    ));
  }
  void openNoteForm(BuildContext context, {Note? isExisting}) {
    this.isExisting = isExisting;
    if (isExisting != null) {
      titleController.text = isExisting.title ?? "";
      descController.text = isExisting.desc ?? "";
    } else {
      titleController.clear();
      descController.clear();
    }
  }
}

class noteList extends StatelessWidget{
  final Function(int) ondelete;
  final Function(Note) onEdit;
  noteList({required this.ondelete,required this.onEdit});
  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<themeProvider>(context,listen: false);

    return Consumer<textFieldProvider>(
        builder:(context,noteProvider,child){
          return noteProvider.notes.isEmpty
              ? Center(
            child: Text(
              "No Notes yet!",
              style: TextStyle(fontSize: 20),
            ),
          )
              : ListView.builder(
            itemCount: noteProvider.notes.length,
            itemBuilder: (context, index) {
              final note = noteProvider.notes[index];
              return Padding(
                padding: const EdgeInsets.only(left: 10.0,bottom: 10,right: 10),
                child: Container(
                  decoration: BoxDecoration(
                      border:Border.all(
                        color: themeChanger.isDark?Colors.transparent: Color(0xFF8080ff),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: themeChanger.isDark? Color(0xFF262626): Colors.white
                  ),
                  child: ListTile(
                    title: Text(note.title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: themeChanger.isDark?Colors.white:Colors.black),),
                    subtitle: Text(note.desc,style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal,color:themeChanger.isDark?Colors.white70:Colors.black)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                           ondelete(note.sno!);
                          },
                          icon: Icon(Icons.delete,size: 30,color: themeChanger.isDark?Color(0xFFa6a6a6): Color(0xFF8080ff),),
                        ),
                        IconButton(
                            onPressed: () {
                              onEdit(note);
                            },
                            icon: Icon(Icons.edit,size: 30,color: themeChanger.isDark?Color(0xFFa6a6a6): Color(0xFF8080ff),)),

                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } );

  }
}

