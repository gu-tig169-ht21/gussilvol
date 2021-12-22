import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'http.dart';
import 'andrasidan.dart';
import 'theme.dart';

void main() {
  runApp(MaterialApp(
    //borde va const
    title: "To-Do",
    home: const Hem(),
    debugShowCheckedModeBanner: false,
    theme: MasterTheme().darkTheme,
  ));
}

class _ApiInput {
  Future<List<TodoList>> inputFromApi() async {
    await APIresponse().fetchList();
    HemState.todoList = List.from(getList);
    return HemState.todoList;
  }
}

class Hem extends StatefulWidget {
  const Hem({Key? key}) : super(key: key);
  @override
  HemState createState() => HemState();
}

class HemState extends State<Hem> {
  Future<List<TodoList>>? futureList;
  static List<TodoList> todoList = <TodoList>[];

  @override
  @mustCallSuper
  void initState() {
    futureList = _ApiInput().inputFromApi();
    super.initState();
  }

  final _filterDD = ["All", "Done", "Undone"];
  String filter = "All";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButton<String>(
            items: _filterDD.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem),
              );
            }).toList(),
            onChanged: (String? newValueSelected) {
              setState(() {
                filter = newValueSelected!;
              });
            },
            value: filter,
          )
        ],
        title: const Text("Att göra lista"),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _filter(filter);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
        future: futureList,
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GorInput()),
            ).then(onBackToMain);
          }),
    );
  }

  Future? onBackToMain(dynamic value) {
    setState(() {
      futureList = _ApiInput().inputFromApi();
    });
  }

  Widget gorLista(List<TodoList> filtrera) {
    return ListView.builder(
        itemCount: todoList.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int n) {
          if (n < filtrera.length) {
            return _gorRad(filtrera[n]);
          } else {
            return const Divider(
              color: Colors.white,
            );
          }
        });
  }

  Widget _gorRad(TodoList text) {
    final _fardig = text.getDone;

    //_input.contains(text) ? null : _input.add(text);
    return Card(
        child: ListTile(
      title: Text(
        text.getTitle,
        style: TextStyle(
          decoration: _fardig ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Icon(
        _fardig ? Icons.check_box : Icons.check_box_outline_blank_outlined,
        color: _fardig ? Colors.purple : null,
      ),
      onTap: () async {
        int index = todoList.indexWhere((item) => item.getId == text.getId);
        if (_fardig) {
          await APIresponse().updateList(text.getTitle, false, text.getId);
          setState(() {
            todoList[index].setDone = false;
          });
        } else {
          await APIresponse().updateList(text.getTitle, true, text.getId);
          setState(() {
            todoList[index].setDone = true;
          });
        }
      },
      trailing: IconButton(
        onPressed: () async {
          await APIresponse().deleteList(text.getId);
          setState(() {
            todoList.removeWhere((item) => item.getId == text.getId);
          });
        },
        icon: const Icon(Icons.delete_outline),
      ),
    ));
  }

  Widget _filter(String val) {
    switch (val) {
      case "All":
        {
          return gorLista(todoList);
        }

      case "Done":
        {
          return gorLista(todoList.where((todo) => todo.done == true).toList());
        }

      case "Undone":
        {
          return gorLista(
              todoList.where((todo) => todo.done == false).toList());
        }
      default:
        {
          return gorLista(todoList);
        }
    }
  }
}
