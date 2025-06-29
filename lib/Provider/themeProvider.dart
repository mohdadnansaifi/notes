import 'dart:core';

import 'package:flutter/cupertino.dart';

class themeProvider with ChangeNotifier{
   bool _isDark=false;
   bool  get isDark =>_isDark;

    void setTheme(bool val){
      _isDark=val;
      notifyListeners();
    }
}