import 'package:chatapp/Post/Transcript.dart';
import 'package:chatapp/Post/admin_screen.dart';
import 'package:chatapp/Post/subject_zero.dart';
import 'package:chatapp/UI/auth/login_screen.dart';
import 'package:chatapp/Utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final auth = FirebaseAuth.instance;
  final CollectionReference subjectCollection =
      FirebaseFirestore.instance.collection('subject');

  final TextEditingController _adminInputController = TextEditingController();

  String UserFullName() {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    return user!.displayName.toString();
  }

  String UserID() {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    return user!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
          actions: [
            IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }).onError((error, stackTrace) {
                  utils().toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout_outlined),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
                child: Text(
                  'Hello!\n${UserFullName()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Transcript'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TranscriptScreen(uid: UserID())));
                },
              ),
              ListTile(
                title: const Text('Chat With Teacher'),
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => TestPage()));
                },
              ),
              ListTile(
                title: const Text('Admin Options'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Admin Options'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text('Enter admin key:'),
                            TextFormField(
                              controller: _adminInputController,
                              decoration: const InputDecoration(
                                labelText: 'Enter Key',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              // Get the text input value
                              if (_adminInputController.text.toString() ==
                                  '03120255506') {
                                setState(() {
                                  _adminInputController.clear();
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminScreen()));
                              } else {
                                utils().toastMessage("Wrong Key!");
                                setState(() {
                                  _adminInputController.clear();
                                });
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: subjectCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  String a = Error().toString();
                  return Text("Some Error " + a);
                }
                final docs = snapshot.data!.docs;
                return Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final documentId = docs[index].id;
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      subjectzero(subject: documentId)));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 17, 1),
                            border: Border.all(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              width: 5.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              documentId,
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
