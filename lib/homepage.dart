import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _tasks = [];
  final String base =
      'https://7ba9254f-dee6-4ae1-91b6-e8295320de1f.mock.pstmn.io/';
  @override
  void initState() {
    super.initState();
    fetchTodos().then((_) {
      setState(() {
        _tasks = _tasks;
      });
    });
  }

  Future<void> fetchTodos() async {
    try {
      final response = await http.get(
        Uri.parse('$base/todo'),
        headers: {'Cache-Control': 'no-cache'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('todo_list')) {
          final List<dynamic> todosData = responseData['todo_list'];
          for (var todo in todosData) {
            if (todo is Map<String, dynamic> && todo.containsKey('task')) {
              _tasks.add(todo['task']);
            }
          }
          // print(_tasks);

          // print('_Tasks added to the global list:');
          // _tasks.forEach((task) => print(task));
        } else {
          if (kDebugMode) {
            print('No _tasks found in the response');
          }
        }
      } else {
        if (kDebugMode) {
          print(
              'Failed to load todo list. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching todo list: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // fetchTodos().then((_) {
    //   setState(() {
    //     _tasks = _tasks;
    //   });
    // });
    return Scaffold(
      appBar: AppBar(
        title: const Text("My-App"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Icon(Icons.notifications),
          ),
          TextButton(
            onPressed: () {},
            child: const Icon(Icons.message),
          ),
        ],
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            _tasks.insert(newIndex, _tasks.removeAt(oldIndex));
          });
        },
        children: [
          for (int ind = 0; ind < _tasks.length; ind++)
            ListTile(
              key: Key('${_tasks[ind]}_$ind'),
              title: Text(
                _tasks[ind],
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            SizedBox(
              height: 130,
              child: DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.add_a_photo_rounded,
                      size: 50,
                    ),
                    Text(
                      "USERNAME",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text("side1"),
            Text("side2"),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          _showInputDialog(context);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        color: Color.fromARGB(255, 19, 196, 209),
        child: Text("bottom bar"),
      ),
    );
  }

  void _showInputDialog(BuildContext context) {
    TextEditingController textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: TextField(
            controller: textFieldController,
            decoration: const InputDecoration(hintText: "Enter item"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('SAVE'),
              onPressed: () {
                setState(() {
                  String newItem = textFieldController.text;
                  if (newItem.isNotEmpty) {
                    _tasks.insert(0, newItem); // Insert at the beginning
                  }
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
