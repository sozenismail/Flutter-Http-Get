import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:httprequestlogin/http_service.dart';
import 'package:httprequestlogin/main.dart';
import 'package:httprequestlogin/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'user_model.dart';

class SecondRoute extends StatelessWidget {

  final String token;

   SecondRoute({this.token});

  HttpService service =new HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Second Screen"),
        ),
        body: Center(
          child: FutureBuilder<UserModel>(
            future: service.userGet(),
            builder: (context, snapshot) {

              if (snapshot.hasData) {
                List<Datum> users = snapshot.data.data;

                return ListView(
                  children: users
                      .map((Datum info) => ListTile(
                            title: Text(info.firstName),
                            subtitle: Text(info.email),
                          ))
                      .toList(),
                );
              } else {}

              return CircularProgressIndicator();
            },
          ),
        ));
  }

  Future<void> cikisyap(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }
}
