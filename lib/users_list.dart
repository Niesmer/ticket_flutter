/* 
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ticket_flutter/supabase.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  late List<UserProfile> users = [];

  @override
  void initState() {
    super.initState();
    users = [];
  }

  void _getUsers() {
    SupaConnect().getUsers().then((value) {
      setState(() {
        users = value.map((user) => User(
          email: user['mail'],
          pseudo: user['pseudo'],
          nom: user['nom'],
          prenom: user['prenom'],
          role: user['role'],
          pass: user['pass'],
          likedIds: user['liked_event_ids'],
        )).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the UsersList object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ListUsers(users: users)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getUsers,
        tooltip: 'Load users',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ListUsers extends StatelessWidget {
  const ListUsers({super.key, required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0, // Define a height for the container
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index].pseudo),
            subtitle: Text(users[index].email),
          );
        },
      ),
    );
  }
}
 */