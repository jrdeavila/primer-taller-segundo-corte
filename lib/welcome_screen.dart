import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final Future<SharedPreferences> _localuser = SharedPreferences.getInstance();
  String? names, lastNames, state, access, color;
  @override
  Future<bool> _loadData() async {
    final SharedPreferences localuser = await _localuser;
    names = localuser.getString('nombres');
    lastNames = localuser.getString('apellidos');
    color = localuser.getString('color');
    state = localuser.getString('estado');
    access = localuser.getString('acceso');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            FutureBuilder(
              future: _loadData(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                List<Widget> children = [];
                if (snapshot.hasData) {
                  children = [
                    const Text("Welcome back",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.blue,
                        )),
                    const SizedBox(height: 5),
                    Text("${names!} ${lastNames!}",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        )),
                    const SizedBox(height: 5),
                    _item("Access:", access!),
                    const SizedBox(height: 5),
                    _item("State:", state!),
                    const SizedBox(height: 5),
                    _item("Color:", color!),
                  ];
                } else if (snapshot.hasError) {
                  children = [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 60),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text("$Error: ${snapshot.error}"))
                  ];
                } else {
                  children = [
                    const SizedBox(
                      child: CircularProgressIndicator(),
                      width: 60,
                      height: 60,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text("Awaiting info..."),
                    ),
                  ];
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                );
              },
            ),
          ])),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
                onPressed: () => _removeData(), child: const Text("REMOVE DATA"))),
      ),
    );
  }

  _removeData() async {
    final userdata = await _localuser;
    userdata.remove('nombres');
    userdata.remove('apellidos');
    userdata.remove('telfono');
    userdata.remove('acceso');
    userdata.remove('color');
    userdata.remove('estado');
    Navigator.pop(context);
  }

  Widget _item(title, content) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(
            width: 5,
          ),
          Text(content)
        ],
      );
}
