import 'package:flutter/material.dart';
import 'package:tokoonline/launcher.dart';
import 'package:tokoonline/users/landingpage.dart' as users;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LauncherPage(),
      routes: <String, WidgetBuilder>{
        '/landingusers': (BuildContext context) => new users.LandingPage(),
        '/keranjangusers': (BuildContext context) =>
            new users.LandingPage(nav: '2'),
        // '/signup': (BuildContext context) => new SignupPage(),
        // '/forgot': (BuildContext context) => new ForgotPage(),
      },
    );
  }
}
