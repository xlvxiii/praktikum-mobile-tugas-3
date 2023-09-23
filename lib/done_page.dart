import 'package:flutter/material.dart';
import 'package:to_do_list_app/db_instance.dart';
import 'sidebar_menu.dart';

class DonePage extends StatefulWidget {
  const DonePage({Key? key}) : super(key: key);

  @override
  _DonePageState createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  List<Map<String, dynamic>> tasks = [];

  void _refreshTasks() async {
    final data = await DbInstance.getDoneTasks();
    setState(() {
      tasks = data;
    });
  }

  void _deleteTask(int id) async {
    await DbInstance.deleteTask(id);
    _refreshTasks();
  }

  Future<void> _undoTask(int id) async {
    await DbInstance.undoTask(id);
    _refreshTasks();
  }

  @override
  void initState() {
    super.initState;
    _refreshTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tugas Selesai'),
      ),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) => Card(
                    child: ListTile(
                      leading: SizedBox(
                        width: 40,
                        child: Checkbox(
                            value: true,
                            onChanged: (bool? value) =>
                                {_undoTask(tasks[index]['id'])}),
                      ),
                      title: Text(
                        tasks[index]['task'],
                        style: const TextStyle(
                            decoration: TextDecoration.lineThrough),
                      ),
                      subtitle: const Text('Selesai'),
                      trailing: SizedBox(
                        width: 50,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () =>
                                    _deleteTask(tasks[index]['id']),
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                      ),
                    ),
                  ))
        ],
      ),
      drawer: const SidebarMenu(),
    );
  }
}
