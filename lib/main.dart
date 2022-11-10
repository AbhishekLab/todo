import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/domain/model/todo_db_entry.dart';
import 'package:todo/presentation/todo/todo.dart';
import 'package:todo/utils/constant.dart';


late Box<TodoDbEntity> box;
Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoDbEntityAdapter());
  box = (await Hive.openBox<TodoDbEntity>(dbName));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoApp(box: box),
    );
  }
}
