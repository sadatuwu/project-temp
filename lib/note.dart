import 'dart:convert';
import 'package:http/http.dart' as http;

List<String> tasks = [];

void main() async {
  print(tasks);
  await fetchAndAddTasks();
  print(tasks);
}

Future<void> fetchAndAddTasks() async {
  final String url =
      'https://7ba9254f-dee6-4ae1-91b6-e8295320de1f.mock.pstmn.io/todo';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('todo_list')) {
        final List<dynamic> todosData = responseData['todo_list'];
        for (var todo in todosData) {
          if (todo is Map<String, dynamic> && todo.containsKey('task')) {
            tasks.add(todo['task']);
          }
        }
        // print('Tasks added to the global list:');
        // tasks.forEach((task) => print(task));
      } else {
        print('No tasks found in the response');
      }
    } else {
      print('Failed to load todo list. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching todo list: $e');
  }
}
