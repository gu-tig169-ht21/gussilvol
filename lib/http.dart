import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

List<todoList> getList = <todoList>[];

class todoList {
  String id, title;
  bool done;
  todoList(this.id, this.title, this.done);
  factory todoList.fromJson(Map<String, dynamic> json) {
    return todoList(
        json['id'] as String, json['title'] as String, json['done'] as bool);
  }
}

var nyckel = '4b96e9a2-ad74-4e49-b7d4-a070bfa68638';

Future<List<todoList>> sendList(String title, bool done) async {
  final response = await http.post(
      Uri.parse(
          'https://todoapp-api-pyq5q.ondigitalocean.app/todos?key=$nyckel'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'title': title}));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var responsOBJson = jsonDecode(response.body) as List;
    getList = responsOBJson
        .map((responsJson) => todoList.fromJson(responsJson))
        .toList();
    return getList;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Lyckades inte hämta listan');
  }
}

Future<List<todoList>> fetchList() async {
  final response = await http.get(Uri.parse(
      'https://todoapp-api-pyq5q.ondigitalocean.app/todos?key=$nyckel'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var responsOBJson = jsonDecode(response.body) as List;
    getList = responsOBJson
        .map((responsJson) => todoList.fromJson(responsJson))
        .toList();
    return getList;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Lyckades inte hämta listan');
  }
}

Future<List<todoList>> updateList(String title, bool done, String id) async {
  final response = await http.put(
      Uri.parse(
          'https://todoapp-api-pyq5q.ondigitalocean.app/todos?key=$nyckel'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'title': title}));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var responsOBJson = jsonDecode(response.body) as List;
    getList = responsOBJson
        .map((responsJson) => todoList.fromJson(responsJson))
        .toList();
    return getList;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Lyckades inte uppdatera listan');
  }
}

Future<List<todoList>> deleteList(String id) async {
  final http.Response response = await http.delete(
    Uri.parse(
        'https://docs.flutter.dev/cookbook/networking/delete-datatodos?key=$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var responsOBJson = jsonDecode(response.body) as List;
    getList = responsOBJson
        .map((responsJson) => todoList.fromJson(responsJson))
        .toList();
    return getList;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Lyckades inte hämta listan');
  }
}
