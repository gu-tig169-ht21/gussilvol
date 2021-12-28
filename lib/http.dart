import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoList {
  String id, title;
  bool done;
  TodoList(this.id, this.title, this.done);
  factory TodoList.fromJson(Map<String, dynamic> json) {
    return TodoList(
        json['id'] as String, json['title'] as String, json['done'] as bool);
  }

  @override
  String toString() {
    return title;
  }

  bool get getDone {
    return done;
  }

  String get getId {
    return id;
  }

  String get getTitle {
    return title;
  }

  set setDone(bool isDone) {
    done = isDone;
  }
}

var nyckel = '4b96e9a2-ad74-4e49-b7d4-a070bfa68638';

class APIresponse {
  Future<List<TodoList>> sendList(String title, bool done) async {
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
      return responsOBJson
          .map((responsJson) => TodoList.fromJson(responsJson))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Lyckades inte hämta listan');
    }
  }

  Future<List<TodoList>> fetchList() async {
    final response = await http.get(Uri.parse(
        'https://todoapp-api-pyq5q.ondigitalocean.app/todos?key=$nyckel'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responsOBJson = jsonDecode(response.body) as List;
      return responsOBJson
          .map((responsJson) => TodoList.fromJson(responsJson))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Lyckades inte hämta listan');
    }
  }

  Future updateList(String title, bool done, String id) async {
    final response = await http.put(
        Uri.parse(
            'https://todoapp-api-pyq5q.ondigitalocean.app/todos/$id?key=$nyckel'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'title': title, "done": done}));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responsOBJson = jsonDecode(response.body) as List;
      return responsOBJson
          .map((responsJson) => TodoList.fromJson(responsJson))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Lyckades inte uppdatera listan');
    }
  }

  Future<List<TodoList>> deleteList(String id) async {
    final http.Response response = await http.delete(
      Uri.parse(
          'https://todoapp-api-pyq5q.ondigitalocean.app/todos/$id?key=$nyckel'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responsOBJson = jsonDecode(response.body) as List;
      return responsOBJson
          .map((responsJson) => TodoList.fromJson(responsJson))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Lyckades inte ta bort från listan');
    }
  }
}
