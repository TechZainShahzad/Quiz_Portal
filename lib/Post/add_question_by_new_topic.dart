import 'package:chatapp/Utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddQuestionByNewTopicForm extends StatefulWidget {
  final String subject;
  final String topic;

  const AddQuestionByNewTopicForm({super.key, 
    required this.subject,
    required this.topic,
  });

  @override
  _AddQuestionByNewTopicFormState createState() =>
      _AddQuestionByNewTopicFormState();
}

class _AddQuestionByNewTopicFormState extends State<AddQuestionByNewTopicForm> {
  final _formKey = GlobalKey<FormState>();
  late CollectionReference firestore;
  int docIndex = 0;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance
        .collection('subject/${widget.subject}/Topics/${widget.topic}/quiz');
    _getCollectionCount();
  }

  Future<void> _getCollectionCount() async {
    QuerySnapshot querySnapshot = await firestore.get();
    setState(() {
      docIndex = querySnapshot.docs.length;
      docIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final qController = TextEditingController();
    final aController = TextEditingController();
    final bController = TextEditingController();
    final cController = TextEditingController();
    final dController = TextEditingController();
    final correctController = TextEditingController();

    void addQuestionToFirebase() {
      firestore.doc(docIndex.toString()).set({
        'id': docIndex.toString(),
        'question': qController.text.toString(),
        'a': aController.text.toString(),
        'b': bController.text.toString(),
        'c': cController.text.toString(),
        'd': dController.text.toString(),
        'correct': correctController.text.toString(),
      }).then((value) {
        utils().toastMessage("Data Added");
        setState(() {
          qController.clear();
          aController.clear();
          bController.clear();
          cController.clear();
          dController.clear();
          correctController.clear();
        });
      }).onError((error, stackTrace) {
        utils().toastMessage(error.toString());
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text('Add Question at $docIndex')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("Question:"),
                    Expanded(
                      child: TextFormField(
                        controller: qController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a question';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Write Question here",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("1):"),
                    Expanded(
                      child: TextFormField(
                        controller: aController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter option "a"';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Write Option 'a' here",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("2):"),
                    Expanded(
                      child: TextFormField(
                        controller: bController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter option "b"';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Write Option 'b' here",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("3):"),
                    Expanded(
                      child: TextFormField(
                        controller: cController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter option "c"';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Write Option 'c' here",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("4):"),
                    Expanded(
                      child: TextFormField(
                        controller: dController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter option "d"';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Write Option 'd' here",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("Correct:"),
                    Expanded(
                      child: TextFormField(
                        controller: correctController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the correct option number';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Write only the number of 'correct' here",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        addQuestionToFirebase();
                        _getCollectionCount();
                      });
                    }
                  },
                  child: const Text('Add This Question'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
