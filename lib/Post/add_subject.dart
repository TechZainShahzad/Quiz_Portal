import 'package:chatapp/Utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addSubject extends StatefulWidget {
  const addSubject({Key? key}) : super(key: key);

  @override
  State<addSubject> createState() => _addSubjectState();
}

class _addSubjectState extends State<addSubject> {
  final postController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('subject');
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Add a GlobalKey

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subject'),
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
                    return 'Please enter a subject name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Write Subject Name",
                  border: OutlineInputBorder(),
                ),
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
                    }).onError((error, stackTrace) {
                      utils().toastMessage(error.toString());
                    });
                  }
                },
                child: const Text("Add Subject"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
