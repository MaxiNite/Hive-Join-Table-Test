import 'package:flutter/material.dart';
import 'package:hive_join_table_test/database/database.dart';
import 'package:drift/drift.dart' as dr;
import 'package:hive_join_table_test/screens/user_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class UserListSccreen extends StatefulWidget {
  const UserListSccreen({super.key});

  @override
  State<UserListSccreen> createState() => _UserListSccreenState();
}

class _UserListSccreenState extends State<UserListSccreen> {
  late AppDatabase database;
  int axisCount = 2;

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: _getUserListAppBar(),
      body: FutureBuilder<List<UserData>>(
        future: _getUsersFromDB(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserData>? userList = snapshot.data;
            if (userList != null) {
              if (userList.isEmpty) {
                return Center(
                  child: Text(
                    'No Users found, add new ones',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              } else {
                return userListUI(userList);
              }
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
          return Center(
            child: Text(
              'Click on add button to add a new user',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToUserDetail(
            'Add User',
            const UserCompanion(
              name: dr.Value(''),
              username: dr.Value(''),
            ),
          );
        },
        shape: const CircleBorder(
          side: BorderSide(color: Colors.black, width: 2),
        ),
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<List<UserData>> _getUsersFromDB() async {
    return await database.getUsersList();
  }

  Widget userListUI(List<UserData> userList) {
    return StaggeredGridView.countBuilder(
      itemCount: userList.length,
      crossAxisCount: 4,
      itemBuilder: (context, index) {
        UserData userData = userList[index];
        return InkWell(
          onTap: () {
            _navigateToUserDetail(
              'Edit User',
              UserCompanion(
                id: dr.Value(userData.id),
                name: dr.Value(userData.name),
                username: dr.Value(userData.username),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID: ${userData.id}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'NAME: ${userData.name}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'USERNAME: ${userData.username}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.fit(axisCount),
      mainAxisSpacing: 8,
      crossAxisSpacing: 4,
    );
  }

  _navigateToUserDetail(String title, UserCompanion userCompanion) async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailScreen(
          title: title,
          userCompanion: userCompanion,
        ),
      ),
    );

    if (res != null && res == true) {
      setState(() {});
    }
  }

  _getUserListAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.chevron_left_outlined, color: Colors.black),
      ),
      title: const Text(
        'Users',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {
            if (axisCount == 2) {
              axisCount = 4;
            } else {
              axisCount = 2;
            }
            setState(() {});
          },
          icon: Icon(
            axisCount == 4 ? Icons.grid_view : Icons.list,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
