import 'package:chatapp/Post/add_question_in_E1.dart';
import 'package:chatapp/Post/add_subject.dart';
import 'package:chatapp/Post/add_topic.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const addSubject()));
                },
                child: const Text('Add Subject')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const addtopic()));
                },
                child: const Text('Add New Topic In Existing Subject')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddQuestionInE1()));
                },
                child: const Text('Add New Questions In Existing Topic')),
          ],
        ),
      ),
    );
  }
}
