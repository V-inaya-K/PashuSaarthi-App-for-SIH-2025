import 'package:flutter/material.dart';
import 'package:pashusaarthi/Authentication/Authentication.dart';
import 'package:pashusaarthi/Authentication/authkey.dart';
import 'package:pashusaarthi/pages/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:vanilla_app/PopupItems/Gemini_chatbot.dart';

// void main() {
//   runApp(const MyApp());
// }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: Login(),
      home:MyIntro(),
    );
  }
}