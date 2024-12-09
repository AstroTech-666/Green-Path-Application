import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProductFinderScreen extends StatefulWidget {
  const ProductFinderScreen({super.key});

  @override
  _ProductFinderScreenState createState() => _ProductFinderScreenState();
}

class _ProductFinderScreenState extends State<ProductFinderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _urls = [
    'https://earthhero.com/collections/all',
    'https://directory.goodonyou.eco/categories/beauty',
  ];

  // Create a list of controllers for each WebView
  late List<WebViewController> _webControllers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _urls.length, vsync: this);

    // Initialize a controller for each URL
    _webControllers = List<WebViewController>.generate(
      _urls.length,
      (_) =>
          WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted),
    );

    // Load URLs into respective controllers
    for (int i = 0; i < _urls.length; i++) {
      _webControllers[i].loadRequest(Uri.parse(_urls[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco-Friendly Product Finder'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Sustainable Products'),
            Tab(text: 'Sustainable Fashion'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _webControllers.map((controller) {
          return WebViewWidget(controller: controller);
        }).toList(),
      ),
    );
  }
}
