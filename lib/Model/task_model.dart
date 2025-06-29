class Task {
  String task;
  int? sno;
  bool isSelected;
  Task({this.sno, required this.task, required this.isSelected});

  Map<String, dynamic> toMap() {
    return {
      's_no': sno,
      'task': task,
      'isSelected': isSelected ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        sno: map['s_no'],
        task: map['task'],
        isSelected: map['isSelected'] == 1);
  }
}
