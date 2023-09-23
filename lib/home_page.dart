import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_app/sidebar_menu.dart';
import 'package:to_do_list_app/db_instance.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? user;

  List<Map<String, dynamic>> tasks = [];

  void _refreshTasks() async {
    final data = await DbInstance.getTasks();
    setState(() {
      tasks = data;
    });
  }

  Future<void> _addTask() async {
    if (_taskController.text != '') {
      await DbInstance.insertTask(_taskController.text);
      _refreshTasks();
      _taskController.text = '';
      // print('number of items = ${tasks.length}');
    }
  }

  void _deleteTask(int id) async {
    await DbInstance.deleteTask(id);
    _refreshTasks();
  }

  Future<void> _markComplete(int id) async {
    await DbInstance.updateTask(id);
    _refreshTasks();
  }

  Future<void> _undoTask(int id) async {
    await DbInstance.undoTask(id);
    _refreshTasks();
  }

  void _loadUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    user = preferences.getString('username');
    setState(() {});
  }

  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  // void _showForm(int id) async {}

  @override
  Widget build(BuildContext context) {
    _loadUsername();
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.all(5),
              child: ListTile(
                leading: SizedBox(
                  width: 40,
                  child: Checkbox(
                      value: tasks[index]['is_done'] == 0 ? false : true,
                      onChanged: (bool? value) => {
                            if (tasks[index]['is_done'] == 0)
                              {
                                _markComplete(tasks[index]['id']),
                                setState(() {})
                              }
                            else
                              {_undoTask(tasks[index]['id']), setState(() {})}
                          }),
                ),
                title: tasks[index]['is_done'] == 0
                    ? Text(tasks[index]['task'])
                    : Text(
                        tasks[index]['task'],
                        style: const TextStyle(
                            decoration: TextDecoration.lineThrough),
                      ),
                subtitle: (tasks[index]['is_done']) == 0
                    ? const Text('Belum selesai')
                    : const Text('Selesai'),
                trailing: SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () => _deleteTask(tasks[index]['id']),
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.only(left: 15),
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                        hintText: 'Tambah list', border: InputBorder.none),
                  ),
                )),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(50, 50)),
                    child: const Icon(Icons.add),
                    onPressed: () async {
                      await _addTask();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
      drawer: const SidebarMenu(),
    );
  }
}
