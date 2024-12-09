import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> quizzes = [
    {
      "title": "Test Your Climate Change IQ",
      "description":
          "A quiz to challenge your understanding of climate change.",
      "url": "https://www.uncclearn.org/quiz/test-your-climate-change-iq/"
    },
    {
      "title": "NASA Climate Quizzes",
      "description":
          "Explore interactive quizzes about climate science from NASA.",
      "url": "https://climate.nasa.gov/explore/interactives/quizzes/?intent=121"
    },
  ];

  late TabController _tabController;
  late List<WebViewController> _webControllers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: quizzes.length, vsync: this);

    // Initialize WebViewControllers for each quiz URL
    _webControllers = List.generate(
      quizzes.length,
      (_) =>
          WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted),
    );

    // Load the URLs into the respective WebViewControllers
    for (int i = 0; i < quizzes.length; i++) {
      _webControllers[i].loadRequest(Uri.parse(quizzes[i]['url']!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Environmental Quizzes"),
        backgroundColor: Colors.green,
        bottom: TabBar(
          controller: _tabController,
          tabs: quizzes.map((quiz) => Tab(text: quiz['title'])).toList(),
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
