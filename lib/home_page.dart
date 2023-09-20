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
  bool isLoading = true;

  void _refreshTasks() async {
    final data = await DbInstance.getUndoneTasks();
    setState(() {
      tasks = data;
      isLoading = false;
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
        title: const Text('HomePage'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.all(5),
              child: ListTile(
                title: Text(tasks[index]['task']),
                trailing: SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () => null, icon: Icon(Icons.delete))
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
                  margin: const EdgeInsets.all(20),
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(hintText: 'Tambah list'),
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
