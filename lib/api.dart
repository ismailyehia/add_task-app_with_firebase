import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  List posts = [];
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getposts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("posts"),
        ),
        body: (posts.length == 0 && loading == false)
            ? Center(child: Text("no posts"))
            : (posts.length == 0 && loading == true)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(posts[index]['title'],style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),),
                        subtitle: Text(posts[index]['body']),
                      );
                    },
                  ));
  }

  getposts() async {
    setState(() {
      loading = true;
      posts.clear();
    });
    Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

    var request = await http.get(url);

    setState(() {
      posts.addAll(convert.jsonDecode(request.body));
      loading = false;
    }); // to update the UI
  }
}
