import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatplan/model/todomodel.dart';
import 'package:creatplan/view/addPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  Stream<QuerySnapshot> readTodos() {
    return db.collection('todos').snapshots();
  }

  Future<void> updateTodo(Todomodel todo) async {
    await db
        .collection('todos')
        .doc(todo.id)
        .update({"isComplated": !todo.isComplated});
  }

  Future<void> deleTodo(Todomodel todo) async {
    await db.collection('todos').doc(todo.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(73, 118, 253, 1),
        centerTitle: true,
        title: const Text(
          'HomePage',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: readTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            final List<Todomodel> todos = snapshot.data!.docs
                .map(
                  (doc) => Todomodel.fromMap(doc.data() as Map<String, dynamic>)
                    ..id = doc.id,
                )
                .toList();
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Card(
                  child: ListTile(
                    title: Text(todo.title),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: todo.isComplated,
                          onChanged: (v) async {
                            await updateTodo(todo);
                          },
                        ),
                        IconButton(
                          onPressed: () async {
                            await deleTodo(todo);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todo.decription ?? ''),
                        Text(todo.author),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Text('error');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(73, 118, 253, 1),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddtodoPage()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
