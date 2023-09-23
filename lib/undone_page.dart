import 'package:flutter/material.dart';
import 'package:to_do_list_app/db_instance.dart';
import 'sidebar_menu.dart';

class UndonePage extends StatefulWidget {
  const UndonePage({Key? key}) : super(key: key);

  @override
  _UndonePageState createState() => _UndonePageState();
}

class _UndonePageState extends State<UndonePage> {
  List<Map<String, dynamic>> tasks = [];

  void _refreshTasks() async {
    final data = await DbInstance.getUndoneTasks();
    setState(() {
      tasks = data;
    });
  }

  Future<void> _markComplete(int id) async {
    await DbInstance.updateTask(id);
    _refreshTasks();
  }

  void _deleteTask(int id) async {
    await DbInstance.deleteTask(id);
    _refreshTasks();
  }

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tugas Belum Selesai'),
      ),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: tasks.length,
              itemBuilder: ((context, index) => Card(
                    child: ListTile(
                      leading: SizedBox(
                        width: 40,
                        child: Checkbox(
                            value: false,
                            onChanged: (bool? value) => {
                                  _markComplete(tasks[index]['id']),
                                }),
                      ),
                      title: Text(tasks[index]['task']),
                      subtitle: const Text('Belum selesai'),
                      trailing: SizedBox(
                        width: 50,
                        child: Row(children: [
                          IconButton(
                              onPressed: () => _deleteTask(tasks[index]['id']),
                              icon: const Icon(Icons.delete))
                        ]),
                      ),
                    ),
                  )))
        ],
      ),
      drawer: const SidebarMenu(),
    );
  }
}
