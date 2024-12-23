import 'package:flutter/material.dart';

class Addtodo extends StatefulWidget {
  Addtodo({super.key, required this.addText});

  final Function({required String changetext}) addText;

  @override
  State<Addtodo> createState() => _AddtodoState();
}

class _AddtodoState extends State<Addtodo> {
  TextEditingController _controllerText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: TextField(
              autofocus: true,
              controller: _controllerText,
              decoration: const InputDecoration(
                hintText: 'Add Todo',
                labelText: 'Todo',
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                if (_controllerText.text != "") {
                  widget.addText(changetext: _controllerText.text);
                }
              },
              child: const Text("ADD")),
        ],
      ),
    );
  }
}
