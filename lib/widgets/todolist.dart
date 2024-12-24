import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  List<String> texts;
  void Function() updateLocalData;
  TodoList({super.key, required this.texts, required this.updateLocalData});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  void showmodelbottomsheet(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 100,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.texts.removeAt(index);
                  });
                  widget.updateLocalData();
                  Navigator.pop(context);
                },
                child: const Text("Mark as done"),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.texts.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.startToEnd,
          background: Container(
            color: Colors.green,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.check),
                ),
              ],
            ),
          ),
          onDismissed: (direction) {
            setState(() {
              widget.texts.removeAt(index);
            });
          },
          child: ListTile(
            onTap: () {
              showmodelbottomsheet(index);
            },
            title: Text(widget.texts[index]),
          ),
        );
      },
    );
  }
}
