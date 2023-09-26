import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase2/main.dart';
import 'package:firebase2/update_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String? uid;
  String? email;
  Map<String, dynamic>? userdata;

  TextEditingController taskcontroller = TextEditingController();

  List tasks = [];
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData().then((_) async {
      await getCurrentUserData();
      await getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            userdata?['name']!,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                SharedPreferences prefs = await SharedPreferences.getInstance();

                prefs.remove("loggedin");

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Authentiction()));
              },
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: taskcontroller,
              maxLines: 3,
              decoration: InputDecoration(hintText: "Task"),
            ),
            ElevatedButton(
              child: Text("Add"),
              onPressed: () async {
                await FirebaseFirestore.instance.collection('tasks').add({
                  'task': taskcontroller.text,
                  'created_at': DateTime.now(),
                  'updated_at': DateTime.now(),
                });
              },
            ),
            (loading == false && tasks.length > 0)
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('tasks')
                        .orderBy('created_at', descending: true)
                        .snapshots(),
                    builder: (BuildContext context, snapshots) {
                      if (snapshots.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: snapshots.data?.docs.length,
                            itemBuilder: (BuildContext context, index) {
                              return Card(
                                margin: EdgeInsets.only(top: 10),
                                child: ListTile(
                                  title:
                                      Text(snapshots.data?.docs[index]['task']),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        child: Icon(Icons.delete),
                                        onTap: () async {
                                          await FirebaseFirestore.instance
                                              .collection('tasks')
                                              .doc(snapshots.data?.docs[index].id)
                                              .delete();
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        child: Icon(Icons.edit),
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateTaskScreen(
                                                        snapshots.data?.docs[index],
                                                      )));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [CircularProgressIndicator()],
                        );
                      }
                    })
                : (loading == false && tasks.length == 0)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No Tasks"),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      )
          ],
        ));
  }

  Future getData() async {
    setState(() {
      uid = firebaseAuth.currentUser?.uid;
      email = firebaseAuth.currentUser?.email;
    });
  }

  Future getCurrentUserData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((response) {
      setState(() {
        userdata = response.data();
      });
    });
  }

  getTasks() {
    FirebaseFirestore.instance
        .collection('tasks')
        .orderBy('created_at', descending: true)
        .snapshots()
        .listen((event) {
      setState(() {
        loading = true;

        tasks.clear();

        tasks.addAll(event.docs);
        loading = false;
      });
    });
  }
}
