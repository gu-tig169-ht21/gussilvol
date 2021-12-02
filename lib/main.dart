import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'http.dart';
import 'andrasidan.dart';
import 'theme.dart';

List<TodoList> input = <TodoList>[];
final textEdit = TextEditingController();

String filter = "All";

// SNo inte MIn kOd din liLLe JÄvEl
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
    input = List.from(getList);
    return input;
  }
}

class Hem extends StatefulWidget {
  const Hem({Key? key}) : super(key: key);
  @override
  _HemState createState() => _HemState();
}

class _HemState extends State<Hem> {
  Future<List<TodoList>>? futureList;

  @override
  @mustCallSuper
  void initState() {
    futureList = _ApiInput().inputFromApi();
    super.initState();
  }

  final _filterDD = ["All", "Done", "Undone"];

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
      onTap: () {
        int index = input.indexWhere((item) => item.getId == text.getId);
        if (_fardig) {
          APIresponse().updateList(text.getTitle, false, text.getId);
          setState(() {
            input[index].setDone = false;
          });
        } else {
          APIresponse().updateList(text.getTitle, true, text.getId);
          setState(() {
            input[index].setDone = true;
          });
        }
      },
      trailing: IconButton(
        onPressed: () {
          APIresponse().deleteList(text.getId);
          setState(() {
            input.removeWhere((item) => item.getId == text.getId);
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
          return gorLista(input);
        }

      case "Done":
        {
          return gorLista(input.where((todo) => todo.done == true).toList());
        }

      case "Undone":
        {
          return gorLista(input.where((todo) => todo.done == false).toList());
        }
      default:
        {
          return gorLista(input);
        }
    }
  }
}
