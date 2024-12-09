import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  _WaterTrackerScreenState createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  int _selectedIndex = 0;
  late WebViewController _controller;

  final List<String> _urls = [
    'https://watercalculator.org/wfc2/q/household/',
    'https://watercalculator.org/educational-resources',
    'https://watercalculator.org/news-articles',
  ];

  @override
  void initState() {
    super.initState();
    // Wait for the WebView to be ready before initializing the controller
    WebViewController webController = WebViewController();
    _controller = webController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(_urls[_selectedIndex]));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Load the selected URL
    _controller.loadRequest(Uri.parse(_urls[_selectedIndex]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Usage Tracker'),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Educational Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News & Articles',
          ),
        ],
      ),
    );
  }
}
