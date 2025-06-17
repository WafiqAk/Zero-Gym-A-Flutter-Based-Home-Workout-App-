import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class ReportPage extends StatefulWidget {
  const ReportPage({super.key});
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String fitnessLevel = "Enter details to see your fitness level.";

  Map<String, dynamic>? progressData;
  int workoutCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchProgress();
  }

  void _fetchProgress() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;

        setState(() {
          workoutCount = data["workoutCount"] is int ? data["workoutCount"] : 0;
          progressData = {
            "calories": data["totalCalories"] is int ? data["totalCalories"] : 0,
          };
        });
      } else {
        // Document doesn't exist yet
        setState(() {
          workoutCount = 0;
          progressData = {"calories": 0};
        });
      }
    } catch (e) {
      print("Error fetching user progress: $e");
      // Optional: show an error or default
      setState(() {
        workoutCount = 0;
        progressData = {"calories": 0};
      });
    }
  }
}


  void _calculateBMI() {
    double weight = double.tryParse(weightController.text) ?? 0;
    double height = double.tryParse(heightController.text) ?? 0;

    if (weight > 0 && height > 0) {
      double bmi = weight / ((height / 100) * (height / 100));
      if (bmi < 18.5) {
        fitnessLevel = "Underweight 😔";
      } else if (bmi >= 18.5 && bmi < 24.9) {
        fitnessLevel = "Healthy Weight ✅";
      } else {
        fitnessLevel = "Overweight 😕";
      }
    } else {
      fitnessLevel = "Please enter valid numbers.";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Workout Report & BMI",),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(48, 164, 108, 1),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Assessment Report", style: TextStyle(fontSize: 24, fontFamily: 'poppins', fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
           
            // Green Box for Workout Progress
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: progressData != null
                  ? Column(
                      children: [
                        _reportItem("Total Workouts Completed", "$workoutCount"),
                        _reportItem("Calories Burned", "${progressData?["calories"] ?? "N/A"} kcal"),
                      ],
                    )
                  : Center(child: CircularProgressIndicator()),
            ),

            SizedBox(height: 20),

            // Blue Box for BMI Section
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 254, 254, 254),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text("BMI Calculator", style: TextStyle(fontSize: 20, fontFamily: 'poppins', fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: weightController,
                          decoration: InputDecoration(
                            labelText: "Weight (kg)",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: heightController,
                          decoration: InputDecoration(
                            labelText: "Height (cm)",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _calculateBMI,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Calculate BMI",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: const Color.fromRGBO(254, 254, 254, 1),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  Text(
                    fitnessLevel,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reportItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: 18, color: Colors.black54)),
        ],
      ),
    );
  }
}