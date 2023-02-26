import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatplan/view/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/todomodel.dart';

class AddtodoPage extends StatefulWidget {
  const AddtodoPage({Key? key}) : super(key: key);
  @override
  _AddtodoPageState createState() => _AddtodoPageState();
}

class _AddtodoPageState extends State<AddtodoPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isComplated = false;
  final _titleController = TextEditingController();
  final _deskController = TextEditingController();
  final _autorController = TextEditingController();

  Future<void> addTodo() async {
    final db = FirebaseFirestore.instance;
    final todo = Todomodel(
      title: _titleController.text,
      decription: _deskController.text,
      isComplated: _isComplated,
      author: _autorController.text,
    );
    await db.collection('todos').add(todo.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(73, 118, 253, 1),
        title: const Text('Addtopage'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _deskController,
                maxLines: 7,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Decription',
                ),
              ),
              CheckboxListTile(
                title: const Text('Is complated'),
                value: _isComplated,
                onChanged: (v) {
                  setState(() {
                    _isComplated = v ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _autorController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Author',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 22, 101, 220)),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const CupertinoAlertDialog(
                            title: Center(
                              child: CupertinoActivityIndicator(radius: 20),
                            ),
                            content: Text('Куто турунуз'),
                          );
                        });
                    await addTodo();
                    // ignore: use_build_context_synchronously
                    Navigator.popUntil(context, (route) => route.isFirst);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Жазуу шарт!!!')),
                    );
                  }
                },
                icon: const Icon(
                  Icons.publish,
                  color: Colors.white,
                ),
                label: const Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
