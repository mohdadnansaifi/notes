class Note {
   int? sno;
   String title;
   String desc;

   Note({this.sno,required this.title, required this.desc});

   factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
        sno : map['s_no'],
        title: map['title'],
        desc: map['desc'],
    );
   }

   Map<String, dynamic> toMap() {
      final map =<String,dynamic>{
         's_no': sno,
         'title': title,
         'desc': desc,
      };
      if (sno != null){
         map['s_no'] = sno;
      }
      return map;
   }
}