import 'package:flutter/material.dart';
import 'auth_sevice.dart';

class LoginPage extends StatefulWidget {
  final Function showSignUp;
  final AuthService auth;

  const LoginPage({super.key, required this.showSignUp, required this.auth});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final user = await widget.auth.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (user != null) {
          // Handle login success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed. Please check your credentials.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9E9EA),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [      
                Image.asset('assets/zero.png', height: 300,), 
                SizedBox(height: 20),
                Text(
                  'LOGIN',
                  style: TextStyle(
                    fontFamily: 'poppins',
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF30A46C)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF30A46C), width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your email' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF30A46C)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF30A46C), width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your password' : null,
                ),
                SizedBox(height: 30),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF30A46C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 100, vertical: 14),
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontFamily: 'POPPINS',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                      ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () => widget.showSignUp(),
                  child: Text(
                    'You have not an account ? SIGN UP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF30A46C),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
