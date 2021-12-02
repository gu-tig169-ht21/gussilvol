import 'package:flutter/material.dart';
import 'http.dart';
import 'main.dart';

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
            TextField(controller: textEdit),
            const Divider(
              height: 18,
            ),
            OutlinedButton(
                onPressed: () async {
                  setState(() {
                    APIresponse().sendList(textEdit.text, false);
                    APIresponse().fetchList();
                    input = List.from(getList);
                    textEdit.clear();
                    // Navigator.pop(
                    //  context, todoList(_textEdit, false, ""))
                  });
                },
                child: const Text("Add")),
          ],
        )));
  }
}
