import 'package:chatapp/Post/result.dart';
import 'package:chatapp/Utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Function to retrieve the 'correct' field from a document in the 'users' collection

class quizscreen extends StatefulWidget {
  final String topic; // Define a required field for subject
  final String subject;
  const quizscreen({super.key, required this.topic, required this.subject});

  @override
  State<quizscreen> createState() => _quizscreenState();
}

class _quizscreenState extends State<quizscreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference firestore;
  late CollectionReference firestoreUserResult;
  late CollectionReference firestoreUserPercent;

  int targetCounter = 1;
  int _selectedIndex = 0; // Add this line to keep track of the selected index
  int _selectedRadio = 0;
  int docCollectionCount = 0; // Variable to store the document count
  int checkCounter = 0;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance
        .collection('subject/${widget.subject}/Topics/${widget.topic}/quiz');
    String uid = UserId().toString();
    firestoreUserResult =
        FirebaseFirestore.instance.collection('UserResult/$uid/subject');
    initialzeSubject();
    firestoreUserResult = FirebaseFirestore.instance
        .collection('UserResult/$uid/subject/${widget.subject}/Topics');
    initialzeTopic();
    firestoreUserResult = FirebaseFirestore.instance.collection(
        'UserResult/$uid/subject/${widget.subject}/Topics/${widget.topic}/result');
    firestoreUserPercent = FirebaseFirestore.instance
        .collection('UserResult/$uid/subject/${widget.subject}/Topics/');
    _getCollectionCount(); // Initialize the document count when the widget is created
    //initialuserresultdoc();
  }

  Future<void> _getCollectionCount() async {
    QuerySnapshot querySnapshot = await firestore.get();
    setState(() {
      docCollectionCount = querySnapshot.docs.length;
    });
  }

  void initialRemainingDataNull() {
    checkCounter++;
    if ((checkCounter) < docCollectionCount) {
      for (int i = checkCounter; i <= docCollectionCount; i++) {
        firestoreUserResult.doc(i.toString()).set(
          {'select': 99.toString()},
        ).then((value) {
          checkCounter++;
        }).onError((error, stackTrace) {
          utils().toastMessage(error.toString());
        });
      }
    }
  }

  Future<String> getCorrectAnswer(String documentId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('subject/${widget.subject}/Topics/${widget.topic}/quiz')
          .doc(documentId)
          .get();
      if (snapshot.exists) {
        return snapshot.get('correct').toString();
      }
    } catch (e) {
      utils().toastMessage("Error retrieving 'correct' field: $e");
    }
    return ""; // Return an empty string if the document or 'correct' field doesn't exist
  }

  Future<String> getUserAnswer(String documentId) async {
    String uid = UserId();
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(
              'UserResult/$uid/subject/${widget.subject}/Topics/${widget.topic}/result')
          .doc(documentId)
          .get();
      if (snapshot.exists) {
        return snapshot.get('select').toString();
      }
    } catch (e) {
      print("Error retrieving 'correct' field: $e");
    }
    return ""; // Return an empty string if the document or 'correct' field doesn't exist
  }

  Future<String> getPercent() async {
    int start = 1;
    int rightAnswerCount = 0;
    for (int i = start; i <= docCollectionCount; i++) {
      String correctAnswer = await getCorrectAnswer(i.toString());
      String selectAnswer = await getUserAnswer(i.toString());
      if (correctAnswer == selectAnswer) {
        rightAnswerCount++;
      }
    }
    double total = (rightAnswerCount / docCollectionCount) * 100;
    return total.toStringAsFixed(2); // Limit to 2 decimal places
  }

  String UserId() {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    return user!.uid;
  }

  void setResultInUserDoc() async {
    firestoreUserPercent
        .doc(widget.topic)
        .update({'percentage': await getPercent()}).then((value) {
      utils().toastMessage("Result Save in User's Doc");
    }).onError((error, stackTrace) {
      utils().toastMessage(error.toString());
    });
  }

  void initialzeSubject() {
    firestoreUserResult
        .doc(widget.subject.toString())
        .set(
          {'subject': widget.subject.toString()},
        )
        .then((value) {})
        .onError((error, stackTrace) {
          utils().toastMessage(error.toString());
        });
  }

  void initialzeTopic() {
    firestoreUserResult
        .doc(widget.topic.toString())
        .update(
          {'topic': widget.topic.toString()},
        )
        .then((value) {})
        .onError((error, stackTrace) {
          utils().toastMessage(error.toString());
        });
  }

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        if ((index == 2) && (targetCounter < docCollectionCount)) {
          targetCounter++;
          _selectedRadio = 0;
        }
        if ((index == 0) && (targetCounter > 1)) {
          targetCounter--;
          _selectedRadio = 0;
        }
        if ((index == 2) && (targetCounter == docCollectionCount)) {
          utils().toastMessage(
              "This is last question. You must to tap submit after attempt this question");
        }
        if ((index == 0) && (targetCounter == 1)) {
          utils().toastMessage("This is the first question of this quiz");
        }
        if (index == 1) {
          initialRemainingDataNull();
          setResultInUserDoc();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResultScreen(
                        subject: widget.subject,
                        topic: widget.topic,
                        percentage: getPercent(),
                      )));
        }
        _selectedIndex = index; // Update the selected index
      });
    }

    void _onRadioChanged(int? value) {
      if (value != null) {
        setState(() {
          _selectedRadio = value;
          firestoreUserResult.doc(targetCounter.toString()).set(
            {'select': _selectedRadio.toString()},
          ).then((value) {
            //utils().toastMessage("option selected");
            checkCounter++;
          }).onError((error, stackTrace) {
            utils().toastMessage(error.toString());
          });
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic),
      ),
      body: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: _firestore
                .collection(
                    'subject/${widget.subject}/Topics/${widget.topic}/quiz')
                .doc(targetCounter.toString())
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return const CircularProgressIndicator();
              } else {
                final title = snapshot.data!['question'];
                final idcount = snapshot.data!['id'].toString();
                final a = snapshot.data!['a'].toString();
                final b = snapshot.data!['b'].toString();
                final c = snapshot.data!['c'].toString();
                final d = snapshot.data!['d'].toString();

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Q$targetCounter: $title",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      RadioListTile(
                        title: Text(a),
                        value: 1,
                        groupValue: _selectedRadio,
                        onChanged: _onRadioChanged,
                      ),
                      RadioListTile(
                        title: Text(b),
                        value: 2,
                        groupValue: _selectedRadio,
                        onChanged: _onRadioChanged,
                      ),
                      RadioListTile(
                        title: Text(c),
                        value: 3,
                        groupValue: _selectedRadio,
                        onChanged: _onRadioChanged,
                      ),
                      RadioListTile(
                        title: Text(d),
                        value: 4,
                        groupValue: _selectedRadio,
                        onChanged: _onRadioChanged,
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back_ios_new_outlined),
            label: 'Back',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Submit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward_outlined),
            label: 'Next',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped, // Add this line to handle item taps
      ),
    );
  }
}
