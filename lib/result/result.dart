import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  final response = await http.get('https://stevenschulze.io/image/result.json');

  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

class Post {
  final String fileName;
  final String accuracy;
  final bool result;

  Post({this.fileName, this.result, this.accuracy});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        fileName: json["fileName"],
        result: json["result"],
        accuracy: json["accuracy"]);
  }
}

void main() => runApp(MyResult(post: fetchPost()));

class MyResult extends StatelessWidget {
  final Future<Post> post;

  MyResult({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Result'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.result) {
                  return Text("This is a chicken Nugget! \n with " +
                      snapshot.data.accuracy +
                      " accuracy");
                } else {
                  return Text("This is NOT a chicken Nugget!",
                      style: TextStyle(color: Colors.black, fontSize: 22, fontWeight:FontWeight.bold));
                }
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
