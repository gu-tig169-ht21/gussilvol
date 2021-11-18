import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final List<String> _input = <String>[];
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
      body: _filter(filter),
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

  Widget gorLista(List<String> filtrera) {
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

  Widget _gorRad(String text) {
    final _fardig = _klar.contains(text);

    _input.contains(text) ? null : _input.add(text);
    return Card(
        child: ListTile(
      title: Text(
        text,
        style: TextStyle(
          decoration: _fardig ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Icon(
        _fardig ? Icons.check_box : Icons.check_box_outline_blank_outlined,
        color: _fardig ? Colors.pink : null,
      ),
      onTap: () {
        setState(() {
          _fardig ? _klar.remove(text) : _klar.add(text);
        });
      },
      trailing: IconButton(
        onPressed: () {
          setState(() {
            _input.remove(text);
          });
        },
        icon: const Icon(Icons.delete_outline),
      ),
    ));
  }

  Widget _filter(String val) {
    List<String> undone = <String>[];
    switch (val) {
      case "All":
        {
          return gorLista(_input);
        }

      case "Done":
        {
          return gorLista(_klar);
        }

      case "Undone":
        {
          for (int i = 0; i < _input.length; i++) {
            if (!_klar.contains(_input[i])) {
              undone.add(_input[i]);
            }
          }
          return gorLista(undone);
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
                onPressed: () {
                  setState(() {
                    _input.add(_textEdit.text);
                    _textEdit.clear();
                  });
                },
                child: const Text("Add")),
          ],
        )));
  }
}
