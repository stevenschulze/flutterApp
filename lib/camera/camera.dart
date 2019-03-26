import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main() {
  runApp(MyCamera());
}

class MyCamera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Image Picker',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => new MyHomePageState();
}

final String phpEndPoint = 'https://stevenschulze.io/image/backend.php';

class MyHomePageState extends State<MyHomePage> {
  File image;
  Future getImage() async {
    File picture = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 300.0, maxHeight: 500.0);
    setState(() {
      image = picture;
    
      if (image == null) {
        return;
      }

      String base64Image = base64Encode(image.readAsBytesSync());
      String fileName = image.path.split("/").last;

      print(fileName);

      http.post(phpEndPoint, body: {
        "image": base64Image,
        "name": fileName,
      }).then((res) {
        print(res.statusCode);
      }).catchError((err) {
        print(err);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take a Picture'),
      ),
      body: Center(
          child: image == null
              ? Text('Smash the Camera Button to Take a Picture')
              : Image.file(image)),
      drawer: Text("This is the drawer"),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
