import 'package:chatapp/Post/add_question_by_new_topic.dart';
import 'package:chatapp/Utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class postAddTopic extends StatefulWidget {
  final String subject;
  const postAddTopic({super.key, required this.subject});

  @override
  State<postAddTopic> createState() => _postAddTopicState();
}

class _postAddTopicState extends State<postAddTopic> {
  final postController = TextEditingController();
  late CollectionReference firestore;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Add a GlobalKey

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance
        .collection('subject/${widget.subject}/Topics');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add topic in ${widget.subject}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign the form key
          child: ListView(
            children: [
              TextFormField(
                controller: postController,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a topic name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "Write Topic Name", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    firestore
                        .doc(postController.text.toString().toLowerCase())
                        .set({
                      'id': postController.text.toString().toLowerCase(),
                    }).then((value) {
                      utils().toastMessage("Data Added");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddQuestionByNewTopicForm(
                                  subject: widget.subject,
                                  topic: postController.text.toString())));
                    }).onError((error, stackTrace) {
                      utils().toastMessage(error.toString());
                    });
                  }
                },
                child: Text("Add Topic in ${widget.subject}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
