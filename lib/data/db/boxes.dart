import 'package:hive/hive.dart';
import 'package:todo/domain/model/todo_db_entry.dart';
import '../../utils/constant.dart';

class Boxes{
  static Box<TodoDbEntity> todo(){
    if(Hive.isBoxOpen(dbName)){
      Hive.close();
    }
    return Hive.box<TodoDbEntity>(dbName);
  }
}