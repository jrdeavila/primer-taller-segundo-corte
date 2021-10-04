import 'package:flutter/material.dart';
import 'package:sensores/login_component.dart';
import 'package:sensores/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class HomeScreem extends StatefulWidget {
  const HomeScreem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreemState();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Shared Preferences',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
        ),
        home: HomeScreem());
  }
}

class _HomeScreemState extends State<HomeScreem> {
  final Future<SharedPreferences> _localuser = SharedPreferences.getInstance();
  bool _stored = false;

  _verifyStored() async {
    final localuser = await _localuser;
    if (localuser.getString('nombres') != null) {
      setState(() {
        _stored = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: _stored ? const WelcomeScreen() : const LoginComponent(),
    );
  }
}
