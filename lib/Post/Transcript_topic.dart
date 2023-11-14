import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TranscriptTopic extends StatefulWidget {
  final String subject;
  final String uid;
  const TranscriptTopic({super.key, required this.subject, required this.uid});

  @override
  State<TranscriptTopic> createState() => _TranscriptTopicState();
}

class _TranscriptTopicState extends State<TranscriptTopic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject} Transcript'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(
                    'UserResult/${widget.uid}/subject/${widget.subject}/Topics')
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
                    final check = subcollectionDocs[index]['percentage'];
                    return InkWell(
                      onTap: () {},
                      child: ListTile(
                        title: Text(topiccollectionName),
                        trailing: Text('${check.toString()}%'),
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
