import 'package:flutter/material.dart';
import 'package:to_do_list_app/done_page.dart';
import 'package:to_do_list_app/home_page.dart';
import 'package:to_do_list_app/undone_page.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text('Side Menu')),
          ListTile(
            leading: const Icon(Icons.checklist_rounded),
            title: const Text('Checklist'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.done_all_rounded),
            title: const Text('Selesai'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const DonePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.pending_actions_rounded),
            title: const Text('Belum Selesai'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UndonePage()));
            },
          )
        ],
      ),
    );
  }
}
