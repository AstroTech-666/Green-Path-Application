import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalGoalsScreen extends StatefulWidget {
  const PersonalGoalsScreen({super.key});

  @override
  _PersonalGoalsScreenState createState() => _PersonalGoalsScreenState();
}

class _PersonalGoalsScreenState extends State<PersonalGoalsScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _targetDateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  String _status = 'Not Started';
  String _category = 'Choose One';
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final Goals myGoals = Goals();

  void _addGoal() async {
    if (_descriptionController.text.isNotEmpty &&
        _targetDateController.text.isNotEmpty) {
      // Show confetti animation when goal is added successfully
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Lottie.asset('assets/animations/confetti.json'),
        ),
      );

      final userId = FirebaseAuth.instance.currentUser?.uid;

      final newGoal = GoalModel(
        description: _descriptionController.text,
        targetDate: _targetDateController.text,
        progress: _status,
        notes: _notesController.text,
        category: _category,
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('goals')
          .add({
        'description': newGoal.description,
        'targetDate': newGoal.targetDate,
        'progress': newGoal.progress,
        'category': newGoal.category,
        'notes': newGoal.notes,
      });

      // Add goal to the AnimatedList
      myGoals.addGoal(newGoal);
      _listKey.currentState?.setState(() {
        myGoals.goals.clear(); // Clear the list safely
      });

      // Refresh the goal list
      _loadGoals();
      _descriptionController.clear();
      _targetDateController.clear();
      _notesController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal added! 🎉')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
    }
  }

  void _loadGoals() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('goals')
          .get();

      final List<GoalModel> goals = snapshot.docs.map((doc) {
        return GoalModel(
          description: doc['description'],
          targetDate: doc['targetDate'],
          progress: doc['progress'],
          category: doc['category'],
          notes: doc['notes'],
        );
      }).toList();

      if (kDebugMode) {
        print('Goals fetched from Firestore: $goals');
      } // Debugging print

      setState(() {
        myGoals.goals.clear(); // Clear old goals
        myGoals.goals.addAll(goals); // Add new goals from Firestore
      });
      for (int i = 0; i < goals.length; i++) {
        _listKey.currentState?.insertItem(i);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadGoals(); // Ensure goals are loaded when screen starts
  }

  double _calculateProgress() {
    int completedGoals =
        myGoals.goals.where((goal) => goal.progress == 'Completed').length;
    return myGoals.goals.isNotEmpty
        ? completedGoals / myGoals.goals.length
        : 0.0;
  }

  void _updateProgress(GoalModel goal, String newStatus) {
    setState(() {
      myGoals.updateProgress(goal, newStatus);
    });
  }

  void _removeGoal(int index) async {
    if (index >= 0 && index < myGoals.goals.length) {
      final removedGoal = myGoals.goals[index];
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        final goalDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('goals')
            .where('description', isEqualTo: removedGoal.description)
            .limit(1)
            .get();

        if (goalDoc.docs.isNotEmpty) {
          await goalDoc.docs.first.reference.delete();
        }
      }

      setState(() {
        myGoals.goals.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal removed! 🚮')),
      );
    } else {
      if (kDebugMode) {
        print('Invalid index: $index');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = _calculateProgress();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Goals 🏆'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 120,
              child: RadialProgressChart(progress: progress),
            ),
            const SizedBox(height: 10),
            Text(
              '${(progress * 100).toStringAsFixed(0)}% Goals Completed',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildInputField('Goal Description', _descriptionController),
            const SizedBox(height: 10),
            _buildDatePickerField('Target Date', _targetDateController),
            const SizedBox(height: 10),
            _buildDropdown('Category', _category, [
              'Sustainability',
              'Air Protection',
              'Water & Carbon Footprint Tracking',
              'Reduce Transportation',
              'Reduce Waste',
              'Energy Saving',
              'Tree Planting',
              'Education',
              'Others'
            ], (value) {
              setState(() {
                _category = value!;
              });
            }),
            const SizedBox(height: 10),
            _buildInputField('Notes/Comments', _notesController),
            const SizedBox(height: 10),
            _buildDropdown(
                'Status', _status, ['Not Started', 'In Progress', 'Completed'],
                (value) {
              setState(() {
                _status = value!;
              });
            }),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addGoal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
              ),
              child: const Text('Add Goal'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedList(
                key: _listKey,
                initialItemCount: myGoals.goals.length,
                itemBuilder: (context, index, animation) {
                  if (index >= 0 && index < myGoals.goals.length) {
                    final goal = myGoals.goals[index];
                    return GoalCard(
                      goal: goal,
                      onProgressUpdate: (status) =>
                          _updateProgress(goal, status!),
                      onRemove: () => _removeGoal(index),
                      impactAnimation:
                          Lottie.asset('assets/animations/impact.json'),
                    );
                  } else {
                    return const SizedBox(); // Return an empty widget if the index is invalid
                  }
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                if (kDebugMode) {
                  print(_feedbackController.text);
                }

                // Show thumbs-up animation after feedback submission
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Lottie.asset('assets/animations/thumbs_up.json'),
                  ),
                );

                _feedbackController.clear();
              },
              tooltip: 'Submit Feedback',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options,
      Function(String?) onChanged) {
    options = List.from(options)..remove('Choose One');

    return DropdownButtonFormField<String>(
      value: value == 'Choose One' ? null : value,
      items: options
          .map((option) =>
              DropdownMenuItem<String>(value: option, child: Text(option)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          controller.text = "${pickedDate.toLocal()}".split(' ')[0];
        }
      },
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class GoalModel {
  final String description;
  final String targetDate;
  String progress;
  final String category;
  final String notes;

  GoalModel({
    required this.description,
    required this.targetDate,
    this.progress = 'Not Started',
    this.category = 'General',
    this.notes = '',
  });
}

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final ValueChanged<String?>
      onProgressUpdate; // Change to ValueChanged<String?>.
  final VoidCallback onRemove;
  final Widget impactAnimation; // Add this field

  const GoalCard({
    super.key,
    required this.goal,
    required this.onProgressUpdate,
    required this.onRemove,
    required this.impactAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      child: ListTile(
        title: Text(goal.description),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Target Date: ${goal.targetDate}'),
            Text('Status: ${goal.progress}'),
            Text('Notes: ${goal.notes}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: goal.progress,
              items: ['Not Started', 'In Progress', 'Completed']
                  .map((status) => DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: onProgressUpdate,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class Goals {
  final List<GoalModel> goals = [];

  void addGoal(GoalModel goal) {
    goals.add(goal);
  }

  void updateProgress(GoalModel goal, String newStatus) {
    goal.progress = newStatus;
  }

  void removeGoal(GoalModel goal) {
    goals.remove(goal);
  }
}

class RadialProgressChart extends StatelessWidget {
  final double progress; // Progress as a decimal (e.g., 0.75 for 75%)

  const RadialProgressChart({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 10,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ),
        Text(
          '${(progress * 100).toStringAsFixed(0)}%',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }
}
