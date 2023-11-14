import 'package:chatapp/Post/Transcript_topic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TranscriptScreen extends StatefulWidget {
  final String uid;
  const TranscriptScreen({super.key, required this.uid});

  @override
  State<TranscriptScreen> createState() => _TranscriptScreenState();
}

class _TranscriptScreenState extends State<TranscriptScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transcript"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('UserResult/${widget.uid}/subject')
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
                                builder: (context) => TranscriptTopic(
                                    subject: subcollectionName,
                                    uid: widget.uid)));
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
