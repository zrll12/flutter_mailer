import 'package:flutter/material.dart';
import 'package:flutter_mailer/model/email.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EmailDetails extends StatefulWidget {
  const EmailDetails({super.key});

  @override
  State<EmailDetails> createState() => _EmailDetailsState();
}

class _EmailDetailsState extends State<EmailDetails> {
  double _webViewHeight = 400;
  late final WebViewController _controller;
  Email? _email;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false)
      ..addJavaScriptChannel(
        'Height',
        onMessageReceived: (message) {
          setState(() {
            _webViewHeight = double.parse(message.message);
          });
        },
      );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_email == null) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _email = Email.fromMap(args!);
      
      if (_email!.html != 'null' && _email!.html.isNotEmpty) {
        _controller.loadHtmlString('''
          <html>
            <head>
              <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
              <style>
                body { 
                  margin: 0; 
                  padding: 0; 
                  font-family: sans-serif;
                  width: 100%;
                }
                img {
                  max-width: 100%;
                  height: auto;
                }
              </style>
              <script>
                function updateHeight() {
                  Height.postMessage(document.documentElement.scrollHeight);
                }
                window.addEventListener('resize', updateHeight);
                setInterval(updateHeight, 500);
              </script>
            </head>
            <body>${_email!.html}</body>
          </html>
        ''').then((_) {
          Future.delayed(Duration(milliseconds: 100), () {
            _controller.runJavaScript('updateHeight()');
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Detail'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('From: ${_email!.sender}'),
              SizedBox(height: 15),
              Text('To: ${_email!.recipients}'),
              SizedBox(height: 15),
              Text('Subject: ${_email!.subject}'),
              SizedBox(height: 15),
              Text('Date: ${_email!.date}'),
              SizedBox(height: 15),
              Text('Content:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _email!.html != 'null' && _email!.html.isNotEmpty
                  ? SizedBox(
                      height: _webViewHeight,
                      child: WebViewWidget(controller: _controller),
                    )
                  : Text(_email!.text),
            ],
          ),
        ),
      ),
    );
  }
}
