import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'http.dart';

List<todoList> _input = <todoList>[];
final _textEdit = TextEditingController();
final _klar = <String>[];

String filter = "All";

// SNo inte MIn kOd din liLLe JÄvEl
void main() {
  runApp(const MaterialApp(
    title: "To-Do",
    home: Hem(),
    debugShowCheckedModeBanner: false,
  ));
}

class Hem extends StatefulWidget {
  const Hem({Key? key}) : super(key: key);
  @override
  _HemState createState() => _HemState();
}

class _HemState extends State<Hem> {
  late Future<List<todoList>> futureList; //kanske ta bort

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    futureList = fetchList();
  } //kanske ta bort

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

          /*IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                /*Navigator.push( här ska det ligga en dropdpwn meny
                  context,
                  MaterialPageRoute(builder: (context) => const GorInput()),
                ).then((value) => setState(() {}));*/
              })*/
        ],
        title: const Text("Att göra lista"),
      ),
      body: FutureBuilder<List<todoList>>(
        future: futureList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _filter(filter);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GorInput()),
            ).then((value) => setState(() {}));
          }),
    );
  }

  Widget gorLista(List<todoList> filtrera) {
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

  Widget _gorRad(todoList text) {
    final _fardig = text.done;

    _input.contains(text) ? null : _input.add(text);
    return Card(
        child: ListTile(
      title: Text(
        text.title,
        style: TextStyle(
          decoration: _fardig ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Icon(
        _fardig ? Icons.check_box : Icons.check_box_outline_blank_outlined,
        color: _fardig ? Colors.pink : null,
      ),
      onTap: () {
        int index = _input.indexWhere((item) => item.id == text.id);
        if (_fardig) {
          updateList(text.title, false, text.id);
          setState(() {
            _input[index].done = false;
          });
        } else {
          updateList(text.title, true, text.id);
          setState(() {
            _input[index].done = true;
          });
        }
      },
      trailing: IconButton(
        onPressed: () {
          deleteList(text.id);
          setState(() {
            _input.removeWhere((element) => element.id == text.id);
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
          return gorLista(_input);
        }

      case "Done":
        {
          return gorLista(_input.where((todo) => todo.done == true).toList());
        }

      case "Undone":
        {
          return gorLista(_input.where((todo) => todo.done == false).toList());
        }
      default:
        {
          return gorLista(_input);
        }
    }
  }
}

class GorInput extends StatefulWidget {
  const GorInput({Key? key}) : super(key: key);
  @override
  _GorInputState createState() => _GorInputState();
}

class _GorInputState extends State<GorInput> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Lägg till på din att-göra lista"),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            TextField(controller: _textEdit),
            const Divider(
              height: 18,
            ),
            OutlinedButton(
                onPressed: () async {
                  setState(() {
                    sendList(_textEdit.text, false);
                    fetchList();
                    _input = List.from(getList);
                    _textEdit.clear();
                    // Navigator.pop(
                    //  context, todoList(_textEdit, false, ""))
                  });
                },
                child: const Text("Add")),
          ],
        )));
  }
}
