import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:httprequestlogin/second_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';


Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  runApp(MaterialApp(
    home: token == null ? MyApp() : SecondRoute(token: token),
  ));

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'HTTP POST İSLEMİ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //---------------------
  Map<String, String> _user = {};
//---------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            TextField(
                decoration: InputDecoration(hintText: "Email"),
                onChanged: (val) {
                  setState(() {
                    _user['email'] = val;
                  });
                }),
            TextField(
                obscureText: true,
                decoration: InputDecoration(hintText: "Password"),
                onChanged: (val) {
                  setState(() {
                    _user['password'] = val;
                  });
                }),
            OutlineButton(
              child: Text("Register"),
              onPressed: () {
                register();
              },
            )
          ],
        ),
      ),
    );
  }

  void register() {
    // http.post("https://reqres.in/api/login", body: {"email": "eve.holt@reqres.in", "password": "pistol"}).then((res) {
    http.post("https://reqres.in/api/login", body: _user).then((res) async {

      var resJson = json.decode(res.body);
      if (resJson['error'] != null) {
        Toast.show("Hata var ->" + resJson['error'], context,
            gravity: Toast.CENTER);
      } else {
        //Toast.show("Giriş Başarılı " + resJson['token'], context, gravity: Toast.CENTER);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', resJson['token']);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SecondRoute(token: resJson['token'])),
        );
      }
    });
  }


}
