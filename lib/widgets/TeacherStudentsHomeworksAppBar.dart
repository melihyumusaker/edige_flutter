import 'package:flutter/material.dart';

AppBar TeacherStudentsHomeworksAppBar({required String titleText}) {
  return AppBar(
    centerTitle: true,
    title: Text(
      titleText,
      style: TextStyle(color: Colors.white),
    ),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.blue, Colors.green],
        ),
      ),
    ),
  );
}
