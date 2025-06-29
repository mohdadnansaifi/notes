import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/Data/task_DBHelper.dart';
import 'package:notes/Provider/taskProvider.dart';
import 'package:provider/provider.dart';

import '../Provider/themeProvider.dart';

class taskPage extends StatefulWidget{
  @override
  State<taskPage> createState() => _taskPageState();
}


class _taskPageState extends State<taskPage> {
  @override
  @override
  void initState() {
    super.initState();
    // Trigger fetch once on widget load
    Future.delayed(Duration.zero, () {
      Provider.of<TaskProvider>(context, listen: false).getAllTask();
      Provider.of<TaskProvider>(context, listen: false).countTask();
    });
  }

  TextEditingController taskController = TextEditingController();
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<themeProvider>(context,listen: false);
   return Scaffold(
     backgroundColor: themeChanger.isDark ? Colors.black : Color(0xFFe6e6ff),
     appBar: AppBar(
       backgroundColor: themeChanger.isDark ? Colors.black:Color(0xFFe6e6ff),
       title: Text("TaskFlow",style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600,color: themeChanger.isDark?Colors.white:Colors.black )),
       actions: [
         Switch(
           value: themeChanger.isDark,
           onChanged: (value) {
             themeChanger.setTheme(value);
           },
           activeColor: Colors.black,
           activeTrackColor: Colors.white,
           inactiveThumbColor: Colors.blue,
           inactiveTrackColor: Colors.white,
         ),
       ],
     ),
     body: Column(
       // mainAxisAlignment: MainAxisAlignment.start,
       children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text("Hello, Adnan 👋",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: themeChanger.isDark?Colors.white:Colors.black),),
                ],
              ),
            ),
         SizedBox(height: 10,),
         Consumer<TaskProvider>(builder: (context,value,child){
           return Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               Container(
                 width: 180,
                 height: 110,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(20),
                   color: Color(0xFF4d4dff),
                 ),
                 child: Padding(
                   padding: const EdgeInsets.only(top: 15),
                   child: Column(
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(right: 40),
                         child: Text("Completed",style: TextStyle(fontSize: 20,color: Colors.white),),
                       ),
                       SizedBox(height: 10,),
                       Padding(
                         padding: const EdgeInsets.only(right: 120),
                         child: Text('${value.completedTask}',style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),),
                       )
                     ],
                   ),
                 ),
               ),
               Container(
                   width: 180,
                   height: 110,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     color: Color(0xFFa64dff),
                   ),
                   child: Padding(
                     padding: const EdgeInsets.only(top: 15),
                     child: Column(
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(right: 70),
                           child: Text("Pending",style: TextStyle(fontSize: 20,color: Colors.white),),
                         ),
                         SizedBox(height: 10,),
                         Padding(
                           padding: const EdgeInsets.only(right: 120),
                           child: Text('${value.pendingTask}',style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),),
                         ),
                       ],
                     ),
                   )
               )
             ],
           );
         }),
         SizedBox(height: 10,),
         Row(
           children: [
             Expanded(
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: TextField(
                   controller: taskController,
                   decoration: InputDecoration(
                     hintText: "Enter here!",
                     label: Text("Add Your Task 😎"),
                     enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(20),
                         borderSide: BorderSide(color:themeChanger.isDark?Colors.white:Colors.black,width: 2)
                     ),
                     focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(20),
                         borderSide: BorderSide(color: themeChanger.isDark?Colors.white:Colors.black,width: 2)
                     ),
                     border: OutlineInputBorder(),
                   ),
                 ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.only(right: 8,),
               child: ElevatedButton(
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Color(0xFF4d4dff),
                   foregroundColor: Colors.white,
                   minimumSize: Size(80, 58),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(20)
                   )

                 ),
                   onPressed: () {
                     final task = taskController.text.trim();
                     if (task.isNotEmpty) {
                       Provider.of<TaskProvider>(context, listen: false).addTask(task);
                       taskController.clear(); // Optional: Clear the input
                     }
                   },
                   child:Text("Add",style: TextStyle(fontSize: 16),)),
             )
           ],
         ),

         Expanded(
           child: Consumer<TaskProvider>(

             builder: (context, provider, child) {
               print("Rendering ${provider.task.length} tasks"); // DEBUG

               if (provider.task.isEmpty) {
                 return Center(child: Text("No Task Yet!"));
               }

               return ListView.builder(

                 itemCount: provider.task.length,
                 itemBuilder: (context, index) {
                   final task = provider.task[index];
                   return Card(
                     elevation: 3,
                     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                     child: ListTile(
                       title: Text(task.task,style:  TextStyle(fontSize: 20, color: themeChanger.isDark?Colors.white:Colors.black,
                         decoration: task.isSelected
                             ? TextDecoration.lineThrough
                             : TextDecoration.none,
                       ),),
                       leading: Checkbox(
                         value: task.isSelected,
                         onChanged: (value) async {
                           if (value != null && task.sno != null) {
                             await Provider.of<TaskProvider>(context, listen: false)
                                 .ToggleSelectedTask(task.sno!, value);
                           } else {
                             print("Checkbox error: null value or sno");
                           }
                         },
                       ),
                       trailing: IconButton(onPressed: ()async{
                         await provider.deleteTask(task.sno!);

                       }, icon: Icon(CupertinoIcons.delete)),

                     ),
                   );
                 },
               );
             },
           ),
         )

       ],
     ),

   );
  }
}
