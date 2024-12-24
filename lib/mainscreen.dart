import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/addtodo.dart';
import 'package:todoapp/widgets/todolist.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> texts = [];

  void addText({required String changetext}) {
    if (texts.contains(changetext)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Duplicate Task"),
            content: const Text("This task already exists in the list."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }
    setState(() {
      texts.insert(0, changetext);
    });
    updateLocalData();
    Navigator.pop(context);
  }

  void updateLocalData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('texts', texts);
    } catch (e) {
      // Handle error if SharedPreferences fails
      print("Error saving data: $e");
    }
  }

  void getList() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      texts = (prefs.getStringList('texts') ?? []).toList();
      setState(() {});
    } catch (e) {
      // Handle error if SharedPreferences fails
      print("Error loading data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

//on clicking the + icon
  void onClickOficon() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          padding: MediaQuery.of(context).viewInsets,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Addtodo(
            addText: addText,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: onClickOficon,
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              color: const Color.fromARGB(255, 255, 252, 252),
              child: Center(
                child: Text(
                  "Todo",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: InkWell(
                onTap: () {
                  launchUrl(Uri.parse('https://flutter.dev'));
                },
                child: Text('About me',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: InkWell(
                onTap: () {
                  launchUrl(Uri.parse('mainto:anilgithubd@gmail.com'));
                },
                child: Text('Contact',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Todo App"),
        centerTitle: true,
      ),
      body: texts.isEmpty
          ? const Center(
              child: Text(
                "No tasks available. Tap the '+' to add one.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : TodoList(texts: texts, updateLocalData: updateLocalData),
    );
  }
}
