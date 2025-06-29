import 'package:flutter/cupertino.dart';
import 'package:notes/Data/task_DBHelper.dart';
import 'package:notes/Model/task_model.dart';

class TaskProvider with ChangeNotifier{
  List<Task> _task=[];
  List<Task> get task => _task;

  Future<void> getAllTask() async {
    final data = await taskDBHelper.getInctance.getAllTask();
    print("Raw DB Data: $data");
    _task = data.map((e) => Task.fromMap(e)).toList();
    print("Loaded tasks: $_task");
    notifyListeners();
  }


  Future<void> addTask(String task) async {
    // print("Adding task: $task");
    bool success = await taskDBHelper.getInctance.addTask(
      mTask: task,
      mselected: false,
    );
    print("Task added to DB? $success");
    await getAllTask();
    await countTask();
    notifyListeners();
  }

  Future<void> ToggleSelectedTask(int sno, bool isSelected)async{
    await taskDBHelper.getInctance.toggleSelectedTask(sno: sno,isSelected:isSelected);
    await getAllTask();
    await countTask();
    notifyListeners();
  }
  Future<void> deleteTask(int sno)async{
    await taskDBHelper.getInctance.deleteTask(sno: sno);
    await getAllTask();
    await countTask();
    notifyListeners();
  }

  int _completedTask=0;
  int _pendingTask=0;

  int get completedTask =>_completedTask;
  int get pendingTask => _pendingTask;
  Future<void>countTask()async{
    _completedTask=await taskDBHelper.getInctance.countCompletedTask();
    _pendingTask= await taskDBHelper.getInctance.countPendingTask();
    notifyListeners();
  }

}
