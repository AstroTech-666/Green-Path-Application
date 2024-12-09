import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CarbonFootprintScreen extends StatefulWidget {
  const CarbonFootprintScreen({super.key});

  @override
  _CarbonFootprintScreenState createState() => _CarbonFootprintScreenState();
}

class _CarbonFootprintScreenState extends State<CarbonFootprintScreen> {
  late WebViewController _controller;
  final String _url = 'https://coolclimate-calculator-ui.firebaseapp.com/';

  @override
  void initState() {
    super.initState();
    // Initialize the WebView controller and load the URL
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(_url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Footprint Calculator'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
