import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => AuthWrapper()),
    );
  } catch (e) {
    print("Logout Error: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
        backgroundColor: Color(0xFF30A46C),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.info, color: Color(0xFF30A46C)),
              title: Text("About the App"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("About the App"),
                      content: Text("The app developed and designed by: \n AKM.Wafiq \n AA.Showqi \n MKM.Ilahi"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.feedback, color: Color(0xFF30A46C)),
              title: Text("Send Feedback"),
              onTap: () {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'feedback@example.com',
                  query: 'subject=Feedback&body=Your feedback here',
                );
                launchUrl(emailLaunchUri);
              },
            ),

            ListTile(
              leading: Icon(Icons.share, color: Color(0xFF30A46C)),
              title: Text("Share with Friends"),
              onTap: () {
                Share.share('Check out this app: https://yourapp.com');
              },
            ),

            ListTile(
              leading: Icon(Icons.logout, color: Color(0xFF30A46C)),
              title: Text("Logout", style: TextStyle(color: Color(0xFF30A46C))),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}

