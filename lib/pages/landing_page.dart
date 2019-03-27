import 'package:flutter/material.dart';
import './camera.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.greenAccent,
      child: new InkWell(
        onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MyCamera())),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("isNugget!", style: new TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold),),
            new Text("Tap find out if thats a nugget!", style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}