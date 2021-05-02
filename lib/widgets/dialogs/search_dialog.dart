import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flamer/screens/home_screen.dart';
import 'package:flamer/screens/task_screen.dart';
import 'package:flutter/material.dart';

class SearchDialog extends StatefulWidget {
  SearchDialog({Key? key, required CollectionReference tasks, required User user}) : _tasks = tasks, _user = user, super(key: key);

  final CollectionReference _tasks;
  final User _user;

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  
  late Stream<QuerySnapshot> _searchedTasks;
  
  bool? _task1 = false;

  bool _task2 = false;

  bool _task3 = false;
  @override
  void initState() {
    _searchedTasks = widget._tasks.snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: <Widget>[
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 22),
                  child: TextField(
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          _searchedTasks = widget._tasks.where('name', isEqualTo: value).snapshots();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Buscar',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink.shade900),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink.shade900),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink.shade900),
                        ),
                      )
                  ),
                )
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _searchedTasks,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);
            return ListView.separated(
              shrinkWrap: true,
              key: PageStorageKey('SearchScreen'),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => TaskWidget(
                context: context,
                col: widget._tasks,
                doc: snapshot.data!.docs[index],
                onEdit: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskScreen(user: widget._user, doc: snapshot.data!.docs[index]))
                  );
                },
                onDelete: () {
                  Navigator.of(context).pop();
                  widget._tasks.doc(snapshot.data!.docs[index].id).delete();
                },
              ),
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            );
          }
      ),
    );
  }
}