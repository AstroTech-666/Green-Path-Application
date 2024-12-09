import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ResultTableScreen extends StatefulWidget {
  const ResultTableScreen({super.key});

  @override
  _ResultTableScreenState createState() => _ResultTableScreenState();
}

class _ResultTableScreenState extends State<ResultTableScreen> {
  Future<List<Map<String, dynamic>>> _fetchResults() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('results')
          .orderBy('timestamp', descending: true)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['docId'] = doc.id; // Add the document ID to the data map
        return data;
      }).toList();
    }
    return [];
  }

  Future<void> _deleteResult(String docId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('results')
            .doc(docId)
            .delete();
        if (kDebugMode) {
          print("Document deleted: $docId");
        }
      } else {
        if (kDebugMode) {
          print("No user logged in.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting document: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Results'),
        backgroundColor: const Color.fromARGB(255, 1, 80, 72),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchResults(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text('No results found.'));
            }

            final results = snapshot.data!;

            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                final timestamp = result['timestamp']?.toDate();
                final date = timestamp != null
                    ? DateFormat('MMMM d, yyyy').format(timestamp)
                    : 'Unknown';
                final docId =
                    result['docId']; // Make sure docId exists and is correct.
                if (docId == null) {
                  return const Center(
                      child: Text('Error: Missing document ID.'));
                }
                // Assuming docId is present

                return Slidable(
                  // Add slide to delete functionality
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Result'),
                              content: const Text(
                                  'Are you sure you want to delete this result?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await _deleteResult(docId);
                                    setState(
                                        () {}); // Refresh UI after deletion
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Score: ${result['score']?.toString() ?? 'No Score'}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            date,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Message: ${result['message'] ?? 'No Message'}',
                          style: const TextStyle(color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
