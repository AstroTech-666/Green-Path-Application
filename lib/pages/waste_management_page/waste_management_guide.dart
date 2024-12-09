import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'waste_calculator_screen.dart'; // Import the new calculator screen

class WasteManagementGuideScreen extends StatefulWidget {
  const WasteManagementGuideScreen({super.key});

  @override
  _WasteManagementGuideScreen createState() => _WasteManagementGuideScreen();
}

class _WasteManagementGuideScreen extends State<WasteManagementGuideScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _urls = [
    'https://rhodeislandresource.recycle.game',
    'https://thewastegame.iua.ie',
    'https://www.unep.org/topics/chemicals-and-pollution-action/waste',
    'https://www.unep.org/interactives/beat-waste-pollution',
    'https://www.eventbrite.com/d/online/waste/',
  ];

  // List of WebViewControllers for each URL
  late List<WebViewController> _webControllers;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform =
          SurfaceAndroidWebView(); // Avoid WebView errors on Android
    }
    _tabController = TabController(length: _urls.length, vsync: this);

    // Initialize WebViewControllers with JavaScript enabled and media playback allowed
    _webControllers = List.generate(
      _urls.length,
      (_) => WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setMediaPlaybackRequiresUserGesture(false), // Allow media autoplay
    );

    // Load the URLs into the respective WebViewControllers
    for (int i = 0; i < _urls.length; i++) {
      _webControllers[i].loadRequest(Uri.parse(_urls[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Management Guide'),
        backgroundColor: Colors.green[700],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Waste Sorting Game'),
            Tab(text: 'Prevent and Recycle Waste'),
            Tab(text: 'Zero Waste'),
            Tab(text: 'Waste Pollution 101'),
            Tab(text: 'Online Waste Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _webControllers.map((controller) {
          return WebViewWidget(controller: controller);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WasteCalculatorScreen()),
          );
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.calculate),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

extension on WebViewController {
  setMediaPlaybackRequiresUserGesture(bool bool) {}
}

class SurfaceAndroidWebView {}

class WebView {
  static SurfaceAndroidWebView platform = SurfaceAndroidWebView();
}
