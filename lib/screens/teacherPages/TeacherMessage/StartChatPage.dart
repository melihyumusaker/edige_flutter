// ignore_for_file: library_private_types_in_public_api, file_names, must_be_immutable, non_constant_identifier_names

import 'package:edige/controllers/MessageControllers/MessageController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/utils/CustomDecorations.dart';

class StartChatPage extends StatelessWidget {
  StartChatPage({super.key});

  final TextEditingController messageController = TextEditingController();
  final TeacherController teacherController = Get.find<TeacherController>();
  final MessageController msController = Get.find<MessageController>();
  RxInt selectedStudentUserId = RxInt(0);

  void sendMessage() async {
    final int senderId = int.tryParse(teacherController.user_id.value) ?? 0;
    final int receiverId = selectedStudentUserId.value;
    final String messageContent = messageController.text;

    await msController.createMessage(
      senderId,
      receiverId,
      messageContent,
      teacherController.token.toString(),
    );

    await msController.messageList(
      senderId,
      teacherController.token.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StartChatPageAppBar(),
      body: Container(
        decoration: CustomDecorations.buildGradientBoxDecoration(
          Colors.blue,
          Colors.red,
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Dropdown Menu
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: OptionDropdown(onSelected: (int userId) {
                selectedStudentUserId.value = userId;
              }),
            ),
            // Büyük TextField
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildMessageTextField(),
              ),
            ),
            // Gönder Butonu
            _buildSendButton(context),
          ],
        ),
      ),
    );
  }

  AppBar StartChatPageAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.blue,
      title:
          const Text("Konuşma Başlat", style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildMessageTextField() {
    return TextField(
      controller: messageController,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: "Mesajınızı buraya yazın...",
        fillColor: Colors.white.withOpacity(0.8),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return Obx(() {
      if (msController.isLoading.isTrue) {
        // Eğer isLoading true ise, yükleme göstergesini göster
        return const Center(child: CircularProgressIndicator());
      } else {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: sendMessage,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.deepPurpleAccent, // Butonun arka plan rengi
              foregroundColor: Colors.white, // Butonun üzerindeki yazının rengi
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
            ),
            child: const Text(
              'Gönder',
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      }
    });
  }
}

class OptionDropdown extends StatefulWidget {
  final Function(int) onSelected;
  const OptionDropdown({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  @override
  _OptionDropdownState createState() => _OptionDropdownState();
}

class _OptionDropdownState extends State<OptionDropdown> {
  final TeacherController teacherController = Get.find<TeacherController>();
  int? selectedOption; // Seçilen öğrencinin ID'si artık int

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> studentItems =
        teacherController.studentsList.map((student) {
      int userId = student['user']['user_id']; // user_id int olarak alındı
      String fullName =
          "${student['user']['name']} ${student['user']['surname']}";
      return DropdownMenuItem<int>(
        value: userId,
        child: Text(
          fullName,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        onTap: () => widget.onSelected(userId),
      );
    }).toList();

    return DropdownButton<int>(
      value: selectedOption,
      hint: const Text(
        "Öğrenci Seç",
        style: TextStyle(color: Colors.white70, fontSize: 20),
      ),
      underline: Container(height: 2, color: Colors.deepPurpleAccent),
      items: studentItems,
      onChanged: (value) {
        setState(() => selectedOption = value);
      },
    );
  }
}
