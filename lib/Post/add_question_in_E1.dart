import 'package:chatapp/Post/add_question_in_E2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddQuestionInE1 extends StatefulWidget {
  const AddQuestionInE1({super.key});

  @override
  State<AddQuestionInE1> createState() => _AddQuestionInE1State();
}

class _AddQuestionInE1State extends State<AddQuestionInE1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Subject'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(
                    'subject') // Reference to the subcollections using widget.subject
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Text("Some Error");
              }
              final subcollectionDocs = snapshot.data!.docs;
              return Expanded(
                child: ListView.builder(
                  itemCount: subcollectionDocs.length,
                  itemBuilder: (context, index) {
                    final subcollectionName = subcollectionDocs[index].id;
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddQuestionInE2(
                                    subject: subcollectionName)));
                      },
                      child: ListTile(
                        title: Text(subcollectionName),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
