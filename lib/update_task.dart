import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateTaskScreen extends StatefulWidget {
  late var oldTask;

  UpdateTaskScreen(this.oldTask);

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  TextEditingController taskcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    taskcontroller.text = widget.oldTask['task'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("update task"),
      ),
      body: ListView(
        padding: EdgeInsets.all(22),
        children: [
          TextFormField(
            controller: taskcontroller,
            maxLines: 3,
            decoration: InputDecoration(hintText: "Task"),
          ),
          ElevatedButton(
            child: Text("Update"),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('tasks')
                .doc(widget.oldTask.id).update({
                  'task' : taskcontroller.text,
                  'updated_at' : DateTime.now()
                }).then((value) => {
                  Navigator.of(context).pop(),
                });
            },
          ),
        ],
      ),
    );
  }
}
