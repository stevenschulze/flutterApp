import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vibrate/vibrate.dart';


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

final String phpEndPoint = 'https://stevenschulze.io/image/image_handling.php';

class MyHomePageState extends State<MyHomePage> {
  File image;
  bool _saving = false;
  
  Future getImage() async {
    File picture = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 500.0, maxHeight: 700.0);
    setState(() {
      image = picture;
      _saving = true;


      // vibration with result

      var _vibrateSucess = FeedbackType.success;
      //var _viberateFail = FeedbackType.error;
      Vibrate.feedback(_vibrateSucess);

      if (image == null) {
        return;
      }
 
      new Future.delayed(new Duration(seconds: 3), () {
        setState(() {
      

          _saving = false;
        });
      });
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

  Widget _buildWidget() {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
      ),
      body: Center(
          child: image == null
              ? Text('Take a picture of a chicken nugget')
              : Image.file(
                  image,
                  scale: 2.0,
                )),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: getImage,
        child: const Icon(Icons.lens),
        //child: const Icon(Icons.local_see),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: new BottomAppBar(
        color: Colors.greenAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ModalProgressHUD(child: _buildWidget(), inAsyncCall: _saving),
    );
  }
}
