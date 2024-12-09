// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_path/feature_screen.dart';
import 'package:green_path/result_table_screen.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController goalController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  late String userGoal = '';
  late String profileImageUrl = '';
  late String memberSince = '';
  String? selectedGoal;

  Future<void> _saveResultToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final resultData = {
          'userId': user.uid,
          'score': totalScore,
          'message': resultMessage,
          'timestamp': FieldValue.serverTimestamp(),
        };

        // Save the result in Firestore under a collection for this specific user
        await FirebaseFirestore.instance
            .collection('users') // First, locate the user
            .doc(user.uid) // Use the current user's UID
            .collection('results') // Use the "results" subcollection
            .add(resultData); // Add the result data to Firestore

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Result saved successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save result: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not signed in')),
      );
    }
  }

  final List<double> sliderValues = List<double>.filled(20, 0);

  double get totalScore => sliderValues.reduce((a, b) => a + b);

  String get resultMessage {
    if (totalScore <= 20) {
      return "Not environmentally friendly.";
    } else if (totalScore <= 40) {
      return "Minimal effort toward sustainability.";
    } else if (totalScore <= 60) {
      return "Moderately environmentally conscious.";
    } else if (totalScore <= 80) {
      return "Highly environmentally conscious.";
    } else if (totalScore <= 100) {
      return "Environmental champion!";
    } else {
      return "Exceeded maximum score!";
    }
  }

  final List<Map<String, dynamic>> sustainabilityGoals = [
    {"goal": "Reduce Carbon Emissions", "icon": Icons.eco},
    {"goal": "Increase Recycling Rate", "icon": Icons.recycling},
    {"goal": "Conserve Water", "icon": Icons.water_drop},
    {"goal": "Promote Renewable Energy", "icon": Icons.flash_on},
    {"goal": "Zero Waste Lifestyle", "icon": Icons.delete_forever},
    {"goal": "Protect Biodiversity", "icon": Icons.nature},
    {"goal": "Sustainable Agriculture", "icon": Icons.agriculture},
    {"goal": "Reduce Plastic Usage", "icon": Icons.remove_circle_outline},
    {"goal": "Sustainable Transport", "icon": Icons.directions_car},
    {"goal": "Promote Green Building Practices", "icon": Icons.house},
    {"goal": "Reduce Food Waste", "icon": Icons.fastfood},
    {"goal": "Support Local and Ethical Products", "icon": Icons.storefront},
    {"goal": "Protect Forests and Reduce Deforestation", "icon": Icons.eco},
    {"goal": "Support Eco-friendly Packaging", "icon": Icons.card_giftcard},
    {"goal": "Reduce Energy Consumption", "icon": Icons.bolt},
    {"goal": "Promote Circular Economy", "icon": Icons.loop},
    {"goal": "Preserve Wetlands and Natural Habitats", "icon": Icons.water},
    {"goal": "Encourage Eco-friendly Fashion", "icon": Icons.checkroom},
    {"goal": "Raise Awareness on Climate Change", "icon": Icons.public},
    {"goal": "Other (Custom Goal)", "icon": Icons.edit},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            userGoal = userDoc['sustainability_goal'] ?? '';
            selectedGoal = userGoal; // Ensure selectedGoal is not null
            goalController.text = userGoal;
            nameController.text = user.displayName ?? '';
            profileImageUrl = userDoc['photoUrl'] ?? '';
            memberSince = user.metadata.creationTime != null
                ? DateFormat('MMMM d, yyyy').format(user.metadata.creationTime!)
                : 'Unknown';
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
      }
    }
  }

  Future<void> _updateUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Update Firestore with the selected goal
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'sustainability_goal':
              selectedGoal ?? '', // Ensure selectedGoal is saved
          'name': nameController.text.trim(), // Trim unnecessary spaces
        });

        // Update Firebase Auth Display Name
        if (nameController.text.isNotEmpty &&
            nameController.text != user.displayName) {
          await user.updateDisplayName(nameController.text);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  void signUserOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/Login');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign-out failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: profileImageUrl.isNotEmpty
                  ? CachedNetworkImageProvider(profileImageUrl)
                  : null,
              child: profileImageUrl.isEmpty
                  ? const Icon(Icons.account_circle, size: 120)
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
                'Email: ${FirebaseAuth.instance.currentUser?.email ?? 'Not signed in'}'),
            const SizedBox(height: 20),
            Text('Member Since: $memberSince'),
            const SizedBox(height: 20),
            FormBuilderTextField(
              controller: nameController,
              name: 'name',
              decoration: const InputDecoration(
                labelText: 'Your Name',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedGoal?.isEmpty ?? true
                  ? null
                  : selectedGoal, // Ensure proper initialization
              onChanged: (newValue) {
                setState(() {
                  selectedGoal = newValue;
                });
              },
              items: sustainabilityGoals.map((goal) {
                return DropdownMenuItem<String>(
                  value: goal['goal'], // Ensure this value is unique
                  child: Row(
                    children: [
                      Icon(goal['icon']),
                      const SizedBox(width: 10),
                      Text(goal['goal']),
                    ],
                  ),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a sustainability goal.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    "Use this test as your starting point when you first use Green Path. "
                    "Continuously track your progress and reflect on the changes you experience over time. "
                    "Let this test be a reminder of the positive transformation you can achieve "
                    "by using Green Path to stay committed to your sustainability goals.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      final question = [
                        "What do you feel proud of in your recent actions? How do you evaluate your own growth?",
                        "When you look back at your efforts in the past month, what have you learned about your strengths and areas for improvement?",
                        "How do you measure your success? What criteria do you use to assess whether you are on the right path?",
                        "How do you hold yourself accountable for your goals? What actions do you take to stay aligned with your values?",
                        "In moments of difficulty, how do you push yourself to stay focused and take action?",
                        "What motivates you to take action, even when challenges arise? How do you tap into that motivation?",
                        "If you had to evaluate your efforts in contributing to a cause, what would be your measure of impact?",
                        "How do you balance your ambition with the need to take care of yourself and your environment?",
                        "What habits or routines have you adopted that you feel most proud of, and why?",
                        "When you encounter setbacks, how do you reframe the situation to assess what you can learn from it?",
                        "How do you believe your actions impact the environment around you, both in your immediate community and the world at large?",
                        "What steps have you taken recently to make a positive difference in your surroundings?",
                        "What environmental issues resonate with you the most, and how do you feel personally connected to them?",
                        "In what ways do you think your actions today will contribute to a better future for those around you?",
                        "What is your role in shaping a more sustainable or inclusive environment, and how do you evaluate your progress?",
                        "How do you navigate the tension between personal growth and environmental responsibility?",
                        "Do you feel your current lifestyle reflects your environmental values? What changes are you considering to align them further?",
                        "What steps are you taking to raise awareness or inspire others to take positive actions for the environment?",
                        "How do you stay informed about environmental challenges, and how do you incorporate that knowledge into your decision-making?",
                        "How do you assess your own environmental impact, and what goals do you set to minimize it moving forward?",
                      ][index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Slider(
                                value: sliderValues[index],
                                min: 0,
                                max: 5, // Updated max value to 5
                                divisions: 5,
                                label: sliderValues[index].toStringAsFixed(1),
                                onChanged: (newValue) {
                                  setState(() {
                                    sliderValues[index] = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Total Score: ${totalScore.toStringAsFixed(0)}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    resultMessage,
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _updateUserData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 189, 225, 241), // Light blue color
                    ),
                    child: const Text('Update Profile'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FeatureScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 189, 225, 241), // Light blue color
                    ),
                    child: const Text('Go to Features'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveResultToFirestore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 189, 225, 241), // Light blue color
                    ),
                    child: const Text('Save Result'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResultTableScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 189, 225, 241), // Light blue color
                    ),
                    child: const Text('View Your Results'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
