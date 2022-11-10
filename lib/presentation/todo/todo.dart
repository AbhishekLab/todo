import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/utils/custom_widgets.dart';

import '../../domain/model/todo_db_entry.dart';
import '../../utils/constant.dart';
import '../../utils/utils.dart';

class TodoApp extends StatefulWidget {
  TodoApp({Key? key, required this.box}) : super(key: key);

  Box<TodoDbEntity> box;

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  var selectedDate = "";
  late List<TodoDbEntity> todoList ;
  late List<TodoDbEntity> saveTodoList= [];

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ToDo App"),
          actions: [ IconButton(
            onPressed: () async {
              try{
                var jsonData = saveTodoList.map((e) => e.toJson());
                Directory tempDir = await getTemporaryDirectory();
                String tempPath = tempDir.path;
                var file  = File("$tempPath/todo.txt");
                file.writeAsString(jsonData.toString());
                showToast("File Save Successfully");
              }catch(e){
                print(e);
              }
            },
            icon: const Icon(Icons.upload),
          ),],
          bottom: TabBar(
            tabs: [
              Tab(child: customText(today, 20)),
              Tab(child: customText(tomorrow, 20)),
              Tab(child: customText(upcoming, 20)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ValueListenableBuilder<Box<TodoDbEntity>>(
              valueListenable: widget.box.listenable(),
              builder: (context,box,_){
                List<TodoDbEntity> listOfData = box.values.toList().cast<TodoDbEntity>();
                saveTodoList = listOfData;
                todoList = [];
                for(var i in listOfData){
                   if(compareTime(i.date) == "today"){
                     todoList.add(i);
                   }
                }
                return updateList(todoList);
              },
            ),

            ValueListenableBuilder<Box<TodoDbEntity>>(
              valueListenable: widget.box.listenable(),
              builder: (context,box,_){
                List<TodoDbEntity> listOfData = box.values.toList().cast<TodoDbEntity>();
                todoList = [];
                for(var i in listOfData){
                  if(compareTime(i.date) == "tomorrow"){
                    todoList.add(i);
                  }
                }
                return updateList(todoList);
              },
            ),
            ValueListenableBuilder<Box<TodoDbEntity>>(
              valueListenable: widget.box.listenable(),
              builder: (context,box,_){
                List<TodoDbEntity> listOfData = box.values.toList().cast<TodoDbEntity>();
                todoList = [];
                for(var i in listOfData){
                  if(compareTime(i.date) == "upcoming"){
                    todoList.add(i);
                  }
                }
                return updateList(todoList);
              },
            ),
          ],
        ),
        floatingActionButton: InkWell(
            onTap: (){
              showDialog(
                context: context,
                builder: (context){
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState1){
                      return  Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20.0)),
                        child: addTodoIntoList(false,setState1),
                      );
                    },
                  );
                }
              ).whenComplete(() {
                setState(() {
                  selectedDate = "";
                  titleController.clear();
                  descController.clear();
                });
              });
            },
            child: const FloatingActionButton(
                shape: StadiumBorder(),
                onPressed: null,
                backgroundColor: Colors.redAccent,
                child: Icon(
                  Icons.add,
                  size: 20.0,
                ))
        ),
      ),
    );
  }

  Widget updateList(List<TodoDbEntity> todoList) {
    return ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onLongPress: (){
              showDialog(
                  context: context,
                  builder: (context){
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState1){
                        return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(20.0)),
                            child: addTodoIntoList(true, setState1 ,todoList: todoList[index], index: index)
                        );
                      },
                    );
                  }
              );
            },
            child: ExpansionTile(
              title: customText(todoList[index].title, 15),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customText(todoList[index].description, 15),
                      SizedBox(width: 5),
                      customText(todoList[index].date, 15),
                    ],
                  ),
                )

              ],
            ),
          );
        }
    );
  }

  Widget addTodoIntoList(bool isEditing, StateSetter setState1, {TodoDbEntity? todoList, int? index}){
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          customText(isEditing ? "Edit TODO Title" : "Add TODO Title", 20),
          const SizedBox(height: 10),
          TextField(
            controller: isEditing ? TextEditingController(text: todoList?.title) : titleController,
            onChanged: (value){
              setState(() {
                todoList?.title = value;
              });

            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Title',
            ),
          ),
          const SizedBox(height: 10),
          customText("Add TODO Description", 20),
          const SizedBox(height: 10),
          TextField(
            controller: isEditing ? TextEditingController(text: todoList?.description) : descController,
            onChanged: (value){
              todoList?.description = value;
            },
            maxLines : 5,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Description',
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              InkWell(
                onTap: () {
                  selectDate(context, (String data){
                    setState1(() {
                      selectedDate = data;
                    });
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 30,right: 30, top: 10, bottom: 10),
                  color: Colors.redAccent[100],
                  child: customText(selectDateText, 15),
                ),
              ),
              /*const SizedBox(width: 5),
              customText(selectedDate,  15)*/
            ],
          ),

          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isEditing ? InkWell(
                onTap: (){
                  widget.box.delete(todoList?.key);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 30,right: 30, top: 10, bottom: 10),
                  color: Colors.grey,
                  child: customText("Delete", 15),
                ),
              ): Container(),
              InkWell(
                onTap: () async {
                  if(isEditing){
                    if(todoList!.title.toString().isNotEmpty){
                      widget.box.put(todoList.key, TodoDbEntity(title: todoList.title , description: todoList.description, date: selectedDate.isEmpty? todoList.date : selectedDate));
                      Navigator.pop(context);
                    }else{
                      showToast("Please write title ");
                    }

                  }else{
                    if(selectedDate.isNotEmpty){
                      if(titleController.text.isNotEmpty){
                        var entry = TodoDbEntity(title: titleController.text.toString(), description:descController.text.toString(), date: selectedDate);
                        widget.box.add(entry);
                        Navigator.pop(context);
                      }else{
                        showToast("Please write title ");
                      }

                    }else{
                      showToast("Please select date ");
                    }

                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 30,right: 30, top: 10, bottom: 10),
                  color: Colors.grey,
                  child: customText(isEditing ? "Edit" : "Add", 15),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
