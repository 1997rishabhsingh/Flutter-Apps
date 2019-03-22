import 'package:database/models/user.dart';
import 'package:database/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

List _users;

void main() async {
  var db = DatabaseHelper();
  _users = await db.getAllUsers();

  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (_, int position) {//_ means context same as above
          return Card(
            color: Colors.greenAccent.shade100,
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                    '${User.fromMap(_users[position]).username.substring(0, 1)}'),
              ),
              title: Text('User: ${User.fromMap(_users[position]).username}'),
              subtitle: Text('Id: ${User.fromMap(_users[position]).id}'),
              onTap: () =>
                  print('Pass: ${User.fromMap(_users[position]).password}'),
            ),
          );
        },
      ),
    );
  }
}

/*
List _users;
  var db = DatabaseHelper();

  //Add User--
//  await db.saveUser(User('Tunda', 'd54dfd'));

//  Get user count
//  int count = await db.getCount();
//  print('Count?: ' + '$count');

  //Get single user
  User user = await db.getUser(1);
  print('Got user: ${user.username} | pass:${user.password}');

  //Delete user
//  int userDeleted = await db.deleteUser(2);//Id-2 will never gonna exist again!!
//  print('Delete User: Id: $userDeleted');

  //Update
  User ana = await db.getUser(1);
  User updatedAna = User.fromMap(
      {'username': 'UpdatedAna', 'password': 'newpass123', 'id': 1});
  await db.updateUser(updatedAna);


  //Print users in database
  _users = await db.getAllUsers();
  for (int i = 0; i < _users.length; i++) {
    User user = User.map(_users[i]);
    print('Id: ${user.id} | ${user.username} | ${user.password}');
  }

  //print(users);
 */
