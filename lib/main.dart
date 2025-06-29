import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/Pages/taskPage.dart';
import 'package:notes/Provider/taskProvider.dart';
import 'package:notes/Provider/textFieldProvider.dart';
import 'package:notes/Provider/themeProvider.dart';
import 'package:provider/provider.dart';
import 'Pages/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>themeProvider()),
      ChangeNotifierProvider(create: (_)=>textFieldProvider()),
      ChangeNotifierProvider(create: (_)=>TaskProvider())
    ],
    child:Builder(
        builder: (BuildContext context){
          final themeChanger = Provider.of<themeProvider>(context);
      return MaterialApp(
        debugShowCheckedModeBanner: false ,
        title: 'notes app',
        home: homePage(),
        theme: ThemeData(
          scaffoldBackgroundColor:Color(0xFFe6e6ff),
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          brightness: Brightness.dark,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        themeMode:themeChanger.isDark?ThemeMode.dark:ThemeMode.light ,
      );
    }) ,);
  }
}


