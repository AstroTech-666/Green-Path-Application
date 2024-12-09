import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // For syncfusion_flutter_charts
import 'package:intl/intl.dart';

class ChartData {
  ChartData(this.appliance, this.usage, this.color);

  final String appliance;
  final double usage;
  final Color color;
}

class MainEnergyScreen extends StatefulWidget {
  const MainEnergyScreen({super.key});

  @override
  _MainEnergyScreenState createState() => _MainEnergyScreenState();
}

class _MainEnergyScreenState extends State<MainEnergyScreen> {
  // Appliance power usage in kWh per hour
  Map<String, double> appliancePowerUsage = {
    'AC': 16, // kWh/day
    'Fridge': 3.6, // kWh/day
    'Lamp': 0.3, // kWh/day
    'LED': 0.05, // kWh/day
    'Microwave': 0.5, // kWh/day
    'Oven': 2, // kWh/day
    'TV': 0.4, // kWh/day
    'Washing Machine': 0.75, // kWh/day
    'Heater': 7.5, // kWh/day
    'Dishwasher': 1.2, // kWh/day
    'Water Heater': 6, // kWh/day
    'Electric Kettle': 0.75, // kWh/day
    'Electric Stove': 1.5, // kWh/day
    'Freezer': 4.8, // kWh/day
    'Hair Dryer': 0.375, // kWh/day
    'Iron': 0.6, // kWh/day
    'Vacuum Cleaner': 0.5, // kWh/day
    'Devices': 0.16, // kWh/day
  };

  String formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  Color _generateRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  List<ChartData> _createChartDataForPieChart() {
    return applianceUsage.entries.map((entry) {
      double usageInKwh = appliancePowerUsage[entry.key]! * entry.value;
      Color applianceColor =
          applianceColors[entry.key] ?? _generateRandomColor();
      return ChartData(entry.key, usageInKwh, applianceColor);
    }).toList();
  }

  List<ChartData> _createChartDataForColumnChart() {
    return applianceUsage.entries.map((entry) {
      double usageInKwh = appliancePowerUsage[entry.key]! * entry.value;
      Color applianceColor =
          applianceColors[entry.key] ?? _generateRandomColor();
      return ChartData(entry.key, usageInKwh, applianceColor);
    }).toList();
  }

  Widget _buildChart() {
    return Expanded(
      // Wrap the chart in an Expanded widget to give it finite space
      child: SfCircularChart(
        title: const ChartTitle(
          text: 'Energy Usage by Appliance (kWh/day)',
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        series: <CircularSeries>[
          PieSeries<ChartData, String>(
            dataSource: _createChartDataForPieChart(),
            xValueMapper: (ChartData data, _) => data.appliance,
            yValueMapper: (ChartData data, _) => data.usage,
            pointColorMapper: (ChartData data, _) => data.color,
            radius: '80%',
            dataLabelSettings: const DataLabelSettings(
              isVisible: false,
              textStyle: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              overflowMode: OverflowMode.trim,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, double> applianceUsage = {
    'AC': 0.0,
    'Fridge': 0.0,
    'Lamp': 0.0,
    'LED': 0.0,
    'Microwave': 0.0,
    'Oven': 0.0,
    'TV': 0.0,
    'Washing Machine': 0.0,
    'Heater': 0.0,
    'Dishwasher': 0.0,
    'Water Heater': 0.0,
    'Electric Kettle': 0.0,
    'Electric Stove': 0.0,
    'Freezer': 0.0,
    'Hair Dryer': 0.0,
    'Iron': 0.0,
    'Vacuum Cleaner': 0.0,
    'Devices': 0.0,
  };

  Map<String, Color> applianceColors = {
    'AC': Colors.blue,
    'Fridge': Colors.green,
    'Lamp': Colors.yellow,
    'LED': Colors.orange,
    'Microwave': Colors.red,
    'Oven': Colors.brown,
    'TV': Colors.purple,
    'Washing Machine': Colors.cyan,
    'Heater': Colors.pink,
    'Dishwasher': Colors.teal,
    'Water Heater': Colors.indigo,
    'Electric Kettle': Colors.amber,
    'Electric Stove': Colors.blueGrey,
    'Freezer': Colors.lime,
    'Hair Dryer': Colors.deepOrange,
    'Iron': Colors.lightGreen,
    'Vacuum Cleaner': Colors.deepPurple,
    'Devices': Colors.grey,
  };

  double costPerKwh = 0.1654;
  double estimatedCost = 0.0;
  Map<String, double> applianceEstimatedCost = {};
  final TextEditingController _costController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _costController.text = costPerKwh.toString();
  }

  void _calculateEstimatedCost() {
    setState(() {
      applianceEstimatedCost.clear(); // Clear previous cost calculations

      applianceUsage.forEach((appliance, usage) {
        if (usage > 0) {
          // Get the appliance power usage for the calculation
          double appliancePower = appliancePowerUsage[appliance] ?? 0.0;

          // Calculate the total power usage for this appliance (in kWh/day)
          double totalUsage = appliancePower * usage; // usage is in days here

          // Now calculate the cost for this appliance
          double cost = totalUsage * costPerKwh;

          // Store the calculated cost for this appliance
          applianceEstimatedCost[appliance] =
              double.parse(cost.toStringAsFixed(2));
        }
      });

      // Calculate the total cost for all appliances
      estimatedCost =
          applianceEstimatedCost.values.fold(0, (sum, cost) => sum + cost);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Energy Cost Calculator')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMainUI(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _costController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cost per kWh',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        costPerKwh = double.tryParse(value) ?? costPerKwh;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _calculateEstimatedCost,
                    child: const Text('Calculate Estimated Cost'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showEnergySavingTips,
                    child: const Text('Energy Saving Tips'),
                  ),
                  const SizedBox(height: 20),
                  ...applianceEstimatedCost.entries.map((entry) {
                    return Text(
                      '${entry.key}: \$${entry.value.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18),
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainUI() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Appliance Usage Section:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              applianceUsage.isNotEmpty
                  ? GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      itemCount: applianceUsage.length,
                      itemBuilder: (context, index) {
                        String appliance = applianceUsage.keys.elementAt(index);
                        String iconPath =
                            'assets/icons/${appliance.toLowerCase().replaceAll(' ', '_')}.png';
                        return _buildApplianceCard(appliance, iconPath);
                      },
                    )
                  : const Text("No appliances available."),
              const SizedBox(height: 20),
              const Text(
                'Energy Usage by Appliance (Pie Chart):',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              applianceUsage.isNotEmpty
                  ? SizedBox(
                      height: 300, // Ensure the height is constrained
                      child:
                          _buildChart(), // This is the only pie chart you want to keep
                    )
                  : const Text("No chart data available."),
              // Column Chart Section
              const SizedBox(height: 20),
              const Text(
                'Energy Usage by Appliance (Column Chart):',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              applianceUsage.isNotEmpty
                  ? SizedBox(
                      height: 300,
                      child: SfCartesianChart(
                        title:
                            const ChartTitle(text: 'Energy Usage by Appliance'),
                        primaryXAxis: const CategoryAxis(labelRotation: 80),
                        primaryYAxis: const NumericAxis(
                          title: AxisTitle(text: 'Energy Usage (kWh)'),
                        ),
                        series: <CartesianSeries>[
                          ColumnSeries<ChartData, String>(
                            dataSource: _createChartDataForColumnChart(),
                            xValueMapper: (ChartData data, _) => data.appliance,
                            yValueMapper: (ChartData data, _) => data.usage,
                            pointColorMapper: (ChartData data, _) => data.color,
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: false,
                              textStyle: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Text("No appliance usage data available."),
            ],
          ),
        );
      },
    );
  }

  void _showEnergySavingTips() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Energy Saving Tips'),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.lightbulb, color: Colors.yellow),
                  title: Text('Lighting'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Use LED bulbs instead of incandescent lights.'),
                      Text('• Turn off lights when leaving a room.'),
                      Text('• Utilize natural light during the day.'),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.thermostat, color: Colors.red),
                  title: Text('Heating & Cooling'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Set thermostat to 68°F (20°C) in winter.'),
                      Text(
                          '• Use fans instead of air conditioning when possible.'),
                      Text('• Seal windows and doors to prevent heat loss.'),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.kitchen, color: Colors.orange),
                  title: Text('Appliances'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Unplug devices when not in use.'),
                      Text(
                          '• Run washing machines and dishwashers with full loads.'),
                      Text(
                          '• Choose energy-efficient models when replacing appliances.'),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.power, color: Colors.green),
                  title: Text('General Tips'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Monitor your energy usage regularly.'),
                      Text('• Switch to renewable energy if available.'),
                      Text('• Install smart plugs to control device usage.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Got it!'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildApplianceCard(String appliance, String iconPath) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.yellow[100], // Light creamy yellow color for the card
      child: SizedBox(
        width: 180,
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 60,
              height: 60,
              errorBuilder: (_, __, ___) {
                return const Icon(Icons.device_unknown, size: 60);
              },
            ),
            const SizedBox(height: 10),
            Text(
              appliance,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ), // Larger text for better visibility
            ),
            const SizedBox(height: 10),
            Slider(
              min: 0,
              max: 100, // Increased max value to 100 for more usage
              value: applianceUsage[appliance] ?? 0.0, // Use 0.0 if not found
              divisions: 100,
              onChanged: (double value) {
                setState(() {
                  applianceUsage[appliance] = value;
                });
                _calculateEstimatedCost(); // Recalculate cost when slider value changes
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Usage: ${applianceUsage[appliance]?.toStringAsFixed(2)} kWh', // Display current usage in kWh
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Estimated Cost: \$${(appliancePowerUsage[appliance]! * applianceUsage[appliance]! * costPerKwh).toStringAsFixed(2)}', // Show the cost based on usage
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
