import 'package:flutter/material.dart';
import 'package:hive_join_table_test/database/database.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UsernamePicker extends StatefulWidget {
  String username;
  final Function(String) onChange;

  UsernamePicker({super.key, required this.onChange, required this.username});

  @override
  State<UsernamePicker> createState() => _UsernamePickerState();
}

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class _UsernamePickerState extends State<UsernamePicker> {
  late AppDatabase database;

  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    // Future<List<UserData>> userList = database.getUsersList().then((value) => );

    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      underline: Container(
        height: 2,
      ),
      onChanged: (String? value) {
        widget.username = value!;
        widget.onChange(value);
        dropdownValue = value;
        setState(() {});
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
