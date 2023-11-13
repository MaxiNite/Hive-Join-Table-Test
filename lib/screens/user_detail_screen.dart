import 'package:flutter/material.dart';
import 'package:hive_join_table_test/database/database.dart';
import 'package:provider/provider.dart';
// import 'package:intl/intl.dart'; FOR DATE FORMAT
import 'package:drift/drift.dart' as dr;

class UserDetailScreen extends StatefulWidget {
  final String title;
  final UserCompanion userCompanion;

  const UserDetailScreen(
      {super.key, required this.title, required this.userCompanion});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late AppDatabase appDatabase;
  late TextEditingController nameController;
  late TextEditingController usernameController;

  @override
  void initState() {
    nameController = TextEditingController();
    usernameController = TextEditingController();
    nameController.text = widget.userCompanion.name.value;
    usernameController.text = widget.userCompanion.username.value;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _getUserDetailAppbar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'Enter Name'),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'Enter Username'),
            ),
          ],
        ),
      ),
    );
  }

  _getUserDetailAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.chevron_left_outlined,
          color: Colors.black,
        ),
      ),
      title: Text(
        widget.title,
        style: const TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _saveToDb();
          },
          icon: const Icon(
            Icons.save,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {
            _deleteUserFromDb();
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  void _saveToDb() {
    if (widget.userCompanion.id.present) {
      appDatabase
          .updateUser(
            UserData(
              id: widget.userCompanion.id.value,
              name: widget.userCompanion.name.value,
              username: widget.userCompanion.username.value,
            ),
          )
          .then((value) => Navigator.pop(context));
    } else {
      appDatabase
          .insertUser(
            UserCompanion(
              name: dr.Value(nameController.text),
              username: dr.Value(usernameController.text),
            ),
          )
          .then((value) => Navigator.pop(context));
    }
  }

  void _deleteUserFromDb() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete User?'),
          content: const Text('Do you really want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                appDatabase
                    .deleteUser(
                      UserData(
                        id: widget.userCompanion.id.value,
                        name: widget.userCompanion.name.value,
                        username: widget.userCompanion.username.value,
                      ),
                    )
                    .then((value) => Navigator.pop(context));
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
