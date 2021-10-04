import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sensores/request.dart';
import 'package:sensores/welcome_screen.dart';

class LoginComponent extends StatefulWidget {
  const LoginComponent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
  var _usrCtrl, _passCtrl, _nameCtrl;
  bool _authType = true;

  var _emailCtrl;

  var _phoneCtrl;

  var _lastNameCtrl;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: _authType ? _login() : _signup(),
    ));
  }

  @override
  void initState() {
    super.initState();
    _usrCtrl = TextEditingController();
    _passCtrl = TextEditingController();
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _lastNameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
  }

  _entry() => entry(_emailCtrl.text, _passCtrl.text);

  _signUpUser() => addUser(_nameCtrl.text, _lastNameCtrl.text, _passCtrl.text,
      _emailCtrl.text, _usrCtrl.text, _phoneCtrl.text);

  Widget awaitingResultWidget() => Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text("Awaiting result"),
          )
        ],
      );

  _confirmDialog(Future callback) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: FutureBuilder(
            future: callback,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              Widget child;
              if (snapshot.hasData) {
                String result = snapshot.data;
                if (result.isNotEmpty) {
                  child = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 60,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(result)),
                    ],
                  );
                } else {
                  Navigator.pop(context, true);
                  child = Column(
                    mainAxisSize: MainAxisSize.min,
                  );
                }
              } else if (snapshot.hasError) {
                child = Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text("$Error: ${snapshot.error}"))
                ]);
              } else {
                child = awaitingResultWidget();
              }
              return child;
            },
          ));
        }).then((value) {
      if (value == true) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()));
      }
    });
  }

  Widget _login() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _textField("Email",
            controller: _emailCtrl, textInput: TextInputType.emailAddress),
        const SizedBox(
          height: 20,
        ),
        _textField('password', secret: true, controller: _passCtrl),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              _confirmDialog(_entry());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("LOGIN",
                    style: TextStyle(
                      fontSize: 20,
                    )),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.login,
                  size: 30,
                )
              ],
            )),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account?",
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    _authType = false;
                  });
                },
                child: const Text("Sign Up"))
          ],
        ),
      ],
    );
  }

  Widget _signup() {
    return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView(
          children: [
            _textField("Name", controller: _nameCtrl),
            const SizedBox(
              height: 20,
            ),
            _textField("Last Name", controller: _lastNameCtrl),
            const SizedBox(
              height: 20,
            ),
            _textField("Username", controller: _usrCtrl),
            const SizedBox(
              height: 20,
            ),
            _textField("Phone",
                controller: _phoneCtrl, textInput: TextInputType.phone),
            const SizedBox(
              height: 20,
            ),
            _textField("Email",
                controller: _emailCtrl, textInput: TextInputType.emailAddress),
            const SizedBox(
              height: 20,
            ),
            _textField("Password", controller: _passCtrl, secret: true),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  _confirmDialog(_signUpUser());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("SING UP",
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.add_box,
                      size: 30,
                    )
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Do you have an account yet?",
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _authType = true;
                      });
                    },
                    child: const Text("Log In"))
              ],
            ),
          ],
        ));
  }

  TextField _textField(String placeholder,
          {bool secret = false,
          TextEditingController? controller,
          TextInputType textInput = TextInputType.text}) =>
      TextField(
        obscureText: secret,
        keyboardType: textInput,
        controller: controller,
        decoration: InputDecoration(
          labelText: placeholder,
          border: OutlineInputBorder(),
        ),
      );
}
