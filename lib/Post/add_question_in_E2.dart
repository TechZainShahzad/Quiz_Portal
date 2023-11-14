import 'package:chatapp/Post/add_question_by_new_topic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddQuestionInE2 extends StatefulWidget {
  final String subject;
  const AddQuestionInE2({super.key, required this.subject});

  @override
  State<AddQuestionInE2> createState() => _AddQuestionInE2State();
}

class _AddQuestionInE2State extends State<AddQuestionInE2> {
  final postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Topic'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(
                    'subject/${widget.subject}/Topics') // Reference to the subcollections using widget.subject
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
                    final topiccollectionName = subcollectionDocs[index].id;
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddQuestionByNewTopicForm(
                                    subject: widget.subject,
                                    topic: topiccollectionName)));
                      },
                      child: ListTile(
                        title: Text(topiccollectionName),
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
