import 'package:flutter/material.dart';
import 'auth_sevice.dart';
import 'login_page.dart';
import 'signup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLogin = true;
  final AuthService _auth = AuthService();

  void toggleView() {
    setState(() => showLogin = !showLogin);
  }

  @override
  Widget build(BuildContext context) {
    return showLogin
        ? LoginPage(showSignUp: toggleView, auth: _auth)
        : SignUpPage(showLogin: toggleView, auth: _auth);
  }
}
