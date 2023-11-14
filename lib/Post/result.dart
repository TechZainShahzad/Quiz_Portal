import 'package:chatapp/Post/home_page.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final String topic;
  final String subject;
  final Future<String> percentage;

  const ResultScreen({super.key, 
    required this.topic,
    required this.subject,
    required this.percentage,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent going back when the back button is pressed
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Quiz Result"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<String>(
                future: widget.percentage,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    double percent =
                        double.tryParse(snapshot.data ?? '0.0') ?? 0.0;
                    String message = getMessage(percent);
                    Color messageColor = getMessageColor(percent);

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          message,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: messageColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Your Score: ${snapshot.data}%',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const homepage()),
                            );
                          },
                          child: const Text('Back to Home'),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getMessage(double percent) {
    if (percent >= 50) {
      return 'Congratulations! You Passed!';
    } else {
      return 'Sorry, You Failed.';
    }
  }

  Color getMessageColor(double percent) {
    return percent >= 50 ? Colors.green : Colors.red;
  }
}
