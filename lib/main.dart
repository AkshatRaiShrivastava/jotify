import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jotify/pages/note_page.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jotify/services/auth%20service/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // Transparent background
      systemNavigationBarIconBrightness: Brightness.dark, // Dark icons
    ),
  );
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // await dotenv.load(fileName: '.env');
  runApp(
    MyApp(), // Wrap your app
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      routes: {'/noteDetails': (context) => NoteDetailScreen()},
    );
  }
}
