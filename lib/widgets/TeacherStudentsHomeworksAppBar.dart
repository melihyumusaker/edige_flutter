// ignore: file_names
// ignore_for_file: non_constant_identifier_names, file_names, duplicate_ignore

import 'package:flutter/material.dart';

AppBar TeacherStudentsHomeworksAppBar({required String titleText}) {
  return AppBar(
    centerTitle: true,
    title: Text(
      titleText,
      style: const TextStyle(color: Colors.white),
    ),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.blue, Colors.green],
        ),
      ),
    ),
  );
}
