import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class WasteCalculatorScreen extends StatefulWidget {
  const WasteCalculatorScreen({super.key});

  @override
  _WasteCalculatorScreenState createState() => _WasteCalculatorScreenState();
}

class _WasteCalculatorScreenState extends State<WasteCalculatorScreen> {
  final TextEditingController weightController = TextEditingController();
  final List<String> selectedTypes = [];
  final List<String> wasteTypes = [
    'Plastic',
    'E-waste',
    'Paper',
    'Metal',
    'Glass',
    'Hazardous',
    'Biomedical',
    'Food',
    'Paint'
  ];

  // Waste Calculator Logic with multiple waste types
  double calculateWaste(double weight, List<String> types) {
    double totalReduction = 0.0;
    for (String type in types) {
      double reduction = 0.0;
      switch (type.toLowerCase()) {
        case 'plastic':
          reduction = weight * 0.9;
          break;
        case 'e-waste':
          reduction = weight * 0.8;
          break;
        case 'paper':
          reduction = weight * 0.7;
          break;
        case 'metal':
          reduction = weight * 0.6;
          break;
        case 'glass':
          reduction = weight * 0.5;
          break;
        case 'hazardous':
          reduction = weight * 0.4;
          break;
        case 'biomedical':
          reduction = weight * 0.3;
          break;
        case 'food':
          reduction = weight * 0.8;
          break;
        case 'paint':
          reduction = weight * 0.35;
          break;
        default:
          reduction = 0.0; // Skip any unrecognized waste type
      }
      totalReduction += reduction;
    }
    return totalReduction;
  }

  double _result = 0.0;

  Widget _buildCheckboxForWasteType(String type) {
    return CheckboxListTile(
      title: Text(
        type,
        style: GoogleFonts.lato(fontSize: 14),
      ),
      value: selectedTypes.contains(type),
      onChanged: (bool? value) {
        setState(() {
          if (value != null) {
            if (value) {
              selectedTypes.add(type);
            } else {
              selectedTypes.remove(type);
            }
          }
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Keeps keyboard from overlapping content
      appBar: AppBar(
        title: Text(
          'Waste Calculator',
          style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.recycle),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Waste Calculator Info'),
                    content: const Text(
                      'This calculator helps estimate the amount of waste reduction '
                      'achieved by recycling various waste types. Enter the weight '
                      'of the waste and select the types to calculate reductions.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            tooltip: 'Recycling Info',
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.circleInfo),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Waste Calculator Info'),
                    content: const Text(
                      'Did you know that improperly disposing of hazardous waste can cause '
                      'long-term damage to the environment? Always ensure you are '
                      'sorting and recycling waste properly to reduce harmful '
                      'impacts on ecosystems and human health.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            tooltip: 'Info',
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Make entire body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Lottie animation for recycling icon
            Lottie.asset(
              'assets/animations/recycling.json',
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  prefixIcon: const Icon(Icons.scale),
                  hintText: 'Enter waste weight in kg',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green[700]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green[700]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                style: GoogleFonts.lato(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),

            // Inserted Collapsible Checkboxes (Recyclable and Non-Recyclable)
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 8), // Adds padding for better spacing
              child: Column(
                children: [
                  ExpansionTile(
                    title: Text('Recyclable Waste',
                        style: GoogleFonts.lato(fontSize: 16)),
                    children: wasteTypes
                        .where((type) => [
                              'Plastic',
                              'Paper',
                              'Metal',
                              'Glass',
                              'Food'
                            ].contains(type))
                        .map((type) => _buildCheckboxForWasteType(type))
                        .toList(),
                  ),
                  ExpansionTile(
                    title: Text('Non-Recyclable Waste',
                        style: GoogleFonts.lato(fontSize: 16)),
                    children: wasteTypes
                        .where((type) => [
                              'E-waste',
                              'Hazardous',
                              'Biomedical',
                              'Paint'
                            ].contains(type))
                        .map((type) => _buildCheckboxForWasteType(type))
                        .toList(),
                  ),
                ],
              ),
            ),

            // Calculate Button and Results
            const SizedBox(height: 20),
            Hero(
              tag: 'calculate_button',
              child: ElevatedButton(
                onPressed: () {
                  if (weightController.text.isNotEmpty &&
                      selectedTypes.isNotEmpty) {
                    double weight = double.tryParse(weightController.text) ?? 0;
                    if (weight <= 0) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Invalid Input'),
                            content: const Text('Please enter a valid weight.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }
                    setState(() {
                      _result = calculateWaste(weight, selectedTypes);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.black.withOpacity(0.2),
                  elevation: 5,
                ),
                child: Text(
                  'Calculate',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (_result > 0)
              Text(
                'Estimated Reduction: ${_result.toStringAsFixed(2)} kg',
                style:
                    GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            // Other waste types table
            Text(
              'Other types of waste to consider:',
              style: GoogleFonts.lato(fontSize: 16),
            ),
            const SizedBox(height: 10),
            DataTable(
              columns: const [
                DataColumn(
                    label: Text('Waste Type', style: TextStyle(fontSize: 14))),
                DataColumn(
                    label: Text('Reduction', style: TextStyle(fontSize: 14))),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(
                      Text('Plastic', style: GoogleFonts.lato(fontSize: 14))),
                  DataCell(Text('90% reduction',
                      style: GoogleFonts.lato(fontSize: 14))),
                ]),
                DataRow(cells: [
                  DataCell(
                      Text('E-waste', style: GoogleFonts.lato(fontSize: 14))),
                  DataCell(Text('80% reduction',
                      style: GoogleFonts.lato(fontSize: 14))),
                ]),
                DataRow(cells: [
                  DataCell(
                      Text('Paper', style: GoogleFonts.lato(fontSize: 14))),
                  DataCell(Text('70% reduction',
                      style: GoogleFonts.lato(fontSize: 14))),
                ]),
                DataRow(cells: [
                  DataCell(
                      Text('Metal', style: GoogleFonts.lato(fontSize: 14))),
                  DataCell(Text('60% reduction',
                      style: GoogleFonts.lato(fontSize: 14))),
                ]),
                DataRow(cells: [
                  DataCell(
                      Text('Glass', style: GoogleFonts.lato(fontSize: 14))),
                  DataCell(Text('50% reduction',
                      style: GoogleFonts.lato(fontSize: 14))),
                ]),
                DataRow(cells: [
                  DataCell(
                      Text('Hazardous', style: GoogleFonts.lato(fontSize: 14))),
                  DataCell(Text('40% reduction',
                      style: GoogleFonts.lato(fontSize: 14))),
                ]),
                DataRow(cells: [
                  DataCell(Text('Biomedical',
                      style: GoogleFonts.lato(fontSize: 14))),
                  DataCell(Text('30% reduction',
                      style: GoogleFonts.lato(fontSize: 14))),
                ]),
                DataRow(cells: [
                  DataCell(Text('Food', style: GoogleFonts.lato(fontSize: 14))),
                  DataCell(Text('80% reduction',
                      style: GoogleFonts.lato(fontSize: 14))),
                ]),
                DataRow(
                  cells: [
                    DataCell(
                        Text('Paint', style: GoogleFonts.lato(fontSize: 14))),
                    DataCell(Text('35% reduction',
                        style: GoogleFonts.lato(fontSize: 14))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
