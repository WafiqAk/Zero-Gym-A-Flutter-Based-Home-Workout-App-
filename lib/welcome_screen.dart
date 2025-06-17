import 'package:flutter/material.dart';
import 'main.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFE9E9EA),
          body: SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60), 
            Image.asset(
              'assets/wel.png',
              height: 400,
            ),
            SizedBox(height: 20),
            Text(
              "Welcome!",
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'poppins',
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "Your Fitness, Zero Limits\nAnytime, Anywhere!",
              style: TextStyle(fontSize: 15, fontFamily: 'poppins', color:  Color.fromARGB(255, 0, 0, 0)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthWrapper()),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor:  Color(0xFF30A46C),
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              ),
              child: Text(
                "Get Started",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 40), 
          ],
        ),
      ),
    ),
  );
  }
}
