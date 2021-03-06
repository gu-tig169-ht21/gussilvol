import 'package:flutter/material.dart';
import 'http.dart';

class GorInput extends StatefulWidget {
  const GorInput({Key? key}) : super(key: key);
  @override
  _GorInputState createState() => _GorInputState();
}

class _GorInputState extends State<GorInput> {
  final textEdit = TextEditingController();
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
                  await APIresponse().sendList(textEdit.text, false);
                  textEdit.clear();
                },
                child: const Text("Add")),
          ],
        )));
  }
}
