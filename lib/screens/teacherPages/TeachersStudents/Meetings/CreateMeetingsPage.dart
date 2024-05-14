// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, file_names

import 'package:edige/controllers/MeetingController.dart';
import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/utils/CustomDecorations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateMeetingsPage extends StatefulWidget {
  final int studentId;

  const CreateMeetingsPage({super.key, required this.studentId});

  @override
  _CreateMeetingsPageState createState() => _CreateMeetingsPageState();
}

class _CreateMeetingsPageState extends State<CreateMeetingsPage> {
  final TextEditingController meetingNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  bool isFormValid = false;

  @override
  void dispose() {
    meetingNameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  void validateForm() {
    setState(() {
      isFormValid = meetingNameController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          locationController.text.isNotEmpty &&
          dateController.text.isNotEmpty &&
          timeController.text.isNotEmpty;
    });
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
      validateForm();
    }
  }

  Future<void> pickTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      final now = DateTime.now();
      final formattedTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      ).toString().substring(11, 16);
      setState(() {
        timeController.text = formattedTime;
      });
      validateForm();
    }
  }

  void handleFormSubmission() async {
    if (isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Toplantı başarıyla oluşturuldu.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen tüm alanları doldurun.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Toplantı Oluştur',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        centerTitle: true,
      ),
      body: Container(
        decoration: CustomDecorations.buildGradientBoxDecoration(
            const Color(0xFF4A90E2), const Color(0xFF50E3C2)),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              buildTextField(
                controller: meetingNameController,
                hintText: 'Toplantı Adı',
                prefixIcon: Icons.group, // Icon specific to the text field
                onChanged: (text) => validateForm(),
              ),
              const SizedBox(height: 15),
              buildTextField(
                controller: descriptionController,
                hintText: 'Toplantı Açıklaması',
                prefixIcon: Icons.description, // Different icon for description
                onChanged: (text) => validateForm(),
              ),
              const SizedBox(height: 15),
              buildTextField(
                controller: locationController,
                hintText: 'Toplantı Mekanı',
                prefixIcon: Icons.place, // Icon specific to location
                onChanged: (text) => validateForm(),
              ),
              const SizedBox(height: 15),
              buildReadOnlyTextField(
                controller: dateController,
                hintText: 'Toplantı Günü',
                prefixIcon:
                    Icons.calendar_today, // Calendar icon for date picker
                onTap: () => pickDate(context),
              ),
              const SizedBox(height: 15),
              buildReadOnlyTextField(
                controller: timeController,
                hintText: 'Toplantı Saati',
                prefixIcon: Icons.access_time, // Time icon for time picker
                onTap: () => pickTime(context),
              ),
              const SizedBox(height: 24),
              createMeetingButton(context),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Center createMeetingButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (isFormValid) {
            await Get.find<MeetingController>().createMeeting(
              widget.studentId,
              Get.find<TeacherController>().teacherId.value,
              meetingNameController.text,
              descriptionController.text,
              dateController.text,
              timeController.text,
              locationController.text,
            );

            await Get.find<MeetingController>()
                .getStudentAndTeacherSpecialMeetings(
              widget.studentId,
              Get.find<TeacherController>().teacherId.value,
              Get.find<TeacherController>().token.value,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Toplantı başarıyla oluşturuldu.'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            // Boş alan uyarısı verilir.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lütfen tüm alanları doldurun.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: null,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
        ).copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: const Text(
              'Toplantı Oluştur',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon, color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildReadOnlyTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon, color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
        ),
        onTap: onTap,
      ),
    );
  }
}
