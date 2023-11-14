import 'package:chatapp/Post/quiz.dart';
import 'package:chatapp/Utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class subjectzero extends StatefulWidget {
  final String subject; // Define a required field for subject
  const subjectzero({super.key, required this.subject});

  @override
  State<subjectzero> createState() => _subjectzeroState();
}

class _subjectzeroState extends State<subjectzero> {
  late CollectionReference firestoreUserPercent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firestoreUserPercent = FirebaseFirestore.instance.collection(
        'UserResult/${utils().UserID()}/subject/${widget.subject}/Topics/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject), // Use the subject in the app bar title
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
                        setState(() {
                          firestoreUserPercent
                              .doc(topiccollectionName.toString())
                              .set(
                                {'percentage': 0.toString()},
                              )
                              .then((value) {})
                              .onError((error, stackTrace) {
                                utils().toastMessage(error.toString());
                              });
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => quizscreen(
                                      topic: topiccollectionName,
                                      subject: widget.subject,
                                    )));
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
