import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_app/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? user;

  void _saveUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('username', _usernameController.text);
  }

  _showDialog(pesan, routeTarget) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(pesan),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => routeTarget));
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(hintText: 'Ketik Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(hintText: 'Ketik Password'),
              obscureText: true,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_usernameController.text == 'user' &&
                      _passwordController.text == 'user123') {
                    _saveUsername();
                    _showDialog('Berhasil login!', const HomePage());
                  } else {
                    _showDialog(
                        'Username atau Password salah!', const LoginPage());
                  }
                },
                child: const Text('Login'))
          ],
        ),
      ),
    );
  }
}
