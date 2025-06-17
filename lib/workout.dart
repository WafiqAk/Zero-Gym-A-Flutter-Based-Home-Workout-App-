import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutScreen extends StatefulWidget {
  final String exerciseName;

  const WorkoutScreen({super.key, required this.exerciseName});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  Map<String, dynamic>? exerciseDetails;
  bool isLoading = true;
  bool errorOccurred = false;

  @override
  void initState() {
    super.initState();
    fetchExerciseDetails();
  }

  Future<void> fetchExerciseDetails() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('exercises')
          .where('name', isEqualTo: widget.exerciseName)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          exerciseDetails = snapshot.docs.first.data();
          isLoading = false;
        });
      } else {
        setState(() {
          errorOccurred = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching exercise details: $e');
      setState(() {
        errorOccurred = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorOccurred
                ? Center(child: Text('Failed to load exercise details'))
                : exerciseDetails == null
                    ? Center(child: Text('Exercise not found'))
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Column(
                          children: [
                            // Back Button
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 9, 105, 12)),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),

                            // Exercise Name
                            Text(
                              widget.exerciseName,
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),

                            // GIF
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                exerciseDetails!['gifUrl'],
                                height: 300,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                            SizedBox(height: 32),

                            // Duration
                            Text(
                              "${exerciseDetails!['duration'].toString().padLeft(2, '0')}:00 sec",
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 16),

                            // Calories
                            Text(
                              "${exerciseDetails!['calories']} cal",
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Spacer(),

                            // Finished Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final user = FirebaseAuth.instance.currentUser;
                                  if (user != null && exerciseDetails != null) {
                                    final userDoc = FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.uid);

                                    await userDoc.set({
                                      'workoutCount': FieldValue.increment(1),
                                      'totalCalories': FieldValue.increment(exerciseDetails!['calories']),
                                    }, SetOptions(merge: true));
                                  }
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF30A46C),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 4,
                                ),
                                child: Text(
                                  'FINISHED',
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30,)
                          ],
                        ),
                      ),
      ),
    );
  }
}
