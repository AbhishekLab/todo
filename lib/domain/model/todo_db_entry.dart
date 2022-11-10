import 'package:hive/hive.dart';
part 'todo_db_entry.g.dart';

@HiveType(typeId: 0)
class TodoDbEntity extends HiveObject {
  TodoDbEntity({required this.title, required this.description, required this.date});

  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String date;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['date'] = date;
    return data;
  }

}