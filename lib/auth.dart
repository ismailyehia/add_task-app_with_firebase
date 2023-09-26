import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Authentiction extends StatefulWidget {
  const Authentiction({super.key});

  @override
  State<Authentiction> createState() => _AuthentictionState();
}

class _AuthentictionState extends State<Authentiction> {
  TextEditingController nameConttroller = TextEditingController();
  TextEditingController phoneConttroller = TextEditingController();
  TextEditingController emailConttroller = TextEditingController();
  TextEditingController passwordConttroller = TextEditingController();

  String? msg;

  int selectedindex = 0;
  int x = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("firebase"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          (msg != null && msg!.isNotEmpty)
              ? Text(
                  "${msg}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : SizedBox(),
          Text(
            "Login",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            controller: emailConttroller,
            decoration: InputDecoration(
              hintText: "Email",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: passwordConttroller,
            decoration: InputDecoration(
              hintText: "Password",
            ),
            obscureText: true,
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: Text("Login"),
            onPressed: () async {
              try {
                
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: emailConttroller.text,
                  password: passwordConttroller.text,
                );

                

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("loggedin", true);

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Home()));
              } on FirebaseAuthException catch (e) {
                if (e.code == 'wrong-password') {
                  setState(() {
                    msg = "The password is wrong.";
                  });
                } else if (e.code == 'Invalid-email') {
                  setState(() {
                    msg = ' email not valid';
                  });
                } else if (e.code == 'user-disabeld') {
                  setState(() {
                    msg = 'account disapeld.';
                  });
                } else if (e.code == 'user-not-found') {
                  setState(() {
                    msg = 'account not found';
                  });
                }
              }
              ;
            },
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 2,
          ),
          Text(
            "Register",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            controller: nameConttroller,
            decoration: InputDecoration(
              hintText: "Name",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: phoneConttroller,
            decoration: InputDecoration(
              hintText: "Phone number",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: emailConttroller,
            decoration: InputDecoration(
              hintText: "Email",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: passwordConttroller,
            decoration: InputDecoration(
              hintText: "Password",
            ),
            obscureText: true,
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              child: Text("Register"),
              onPressed: () async {
                try{
                  UserCredential user =
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailConttroller.text,
                    password: passwordConttroller.text,
                  );



                          await FirebaseFirestore.instance.collection("users").doc(user.user?.uid).set({
                          'name' : nameConttroller.text,
                          'phone' : phoneConttroller.text,
                          'created_at' : DateTime.now(),
                          'updated_at' : DateTime.now(),
                    });


                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool("loggedin", true);

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Home()));
                }on FirebaseAuthException catch (e) {
                if (e.code == 'wrong-password') {
                  setState(() {
                    msg = "The password is wrong.";
                  });
                } else if (e.code == 'Invalid-email') {
                  setState(() {
                    msg = ' email not valid';
                  });
                } else if (e.code == 'user-disabeld') {
                  setState(() {
                    msg = 'account disapeld.';
                  });
                } else if (e.code == 'user-not-found') {
                  setState(() {
                    msg = 'account not found';
                  });
                }
              }
              ;
              }),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
