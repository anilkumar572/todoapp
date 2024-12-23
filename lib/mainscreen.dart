import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/addtodo.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> texts = [];
  String text = "";

  void addText({required String changetext}) {
    if (texts.contains(changetext)) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Container(
                child: Text("Hello"),
              ),
            );
          });
    }
    setState(() {
      texts.insert(0, changetext);
    });
    UpdateLocalData();
    Navigator.pop(context);
  }

  void UpdateLocalData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('texts', texts);
  }

  void getlist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    texts = (prefs.getStringList('texts') ?? []).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Drawer(
          child: Center(child: Text("This is Drawer")),
        ),
        appBar: AppBar(
          title: const Text("Todo App"),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 300,
                        padding: MediaQuery.of(context).viewInsets,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Addtodo(
                          addText: addText,
                        ),
                      );
                    });
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add,
                ),
              ),
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: texts.length,
            itemBuilder: (BuildContext, int index) {
              return ListTile(
                onTap: () {
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
                                        texts.removeAt(index);
                                      });
                                      UpdateLocalData();

                                      Navigator.pop(context);
                                    },
                                    child: Text("Mark as done"))),
                          ),
                        );
                      });
                },
                title: Text(texts[index]),
              );
            }));
  }
}
