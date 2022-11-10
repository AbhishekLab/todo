import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

parseDateTime(DateTime customDate) {
  var dateTime = DateTime.parse(customDate.toString());
  var date = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  return date;
}

Future<void> selectDate(BuildContext context, Function(String data) function) async {
  DateTime selectedDate = DateTime.now();
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101));
  if (picked != null) {
    function(picked.toString());
  }
}

String compareTime(String date) {
  var currentDate = DateTime.now();
  var secondDate = DateTime.parse(date);

  if (currentDate.day == secondDate.day &&
      currentDate.month == secondDate.month &&
      currentDate.year == secondDate.year) {
    return "today";
  } else if (currentDate.day + 1 == secondDate.day &&
      currentDate.month == secondDate.month &&
      currentDate.year == secondDate.year) {
    return "tomorrow";
  } else {
    return "upcoming";
  }
}


showToast(String message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.black,
      fontSize: 16.0
  );
}

