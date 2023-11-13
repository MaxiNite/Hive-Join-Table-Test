import 'package:flutter/material.dart';
import 'package:hive_join_table_test/screens/purchase_list_screen.dart';
import 'package:hive_join_table_test/screens/user_list_screen.dart';

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 70,
          left: 70,
          right: 70,
        ),
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 75,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserListSccreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(242, 197, 81, 81),
                    ),
                    child: const Text('User'),
                  ),
                ),
              ),
              const SizedBox(
                width: 75,
              ),
              Expanded(
                child: SizedBox(
                  height: 75,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PurchaseListScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(242, 197, 81, 81),
                    ),
                    child: const Text('Purchase'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
