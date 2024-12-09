import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  late WebViewController _controller;
  final String _url = 'https://greenpath-uszow1.bot.copilot.live';

  @override
  void initState() {
    super.initState();
    // Initialize WebView controller and load the URL
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(_url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Path ChatBot'),
        backgroundColor: Colors.green[700],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
