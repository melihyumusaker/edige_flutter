// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:edige/controllers/LoginController.dart';
import 'package:edige/controllers/MessageControllers/StudentMessageController.dart';
import 'package:edige/screens/studentPages/Messages/StudentChatPage.dart';
import 'package:edige/utils/CustomDecorations.dart';

class StudentMessagesBox extends StatelessWidget {
  const StudentMessagesBox({super.key});

  @override
  Widget build(BuildContext context) {
    final StudentMessageController controller =
        Get.find<StudentMessageController>();

    return Scaffold(
      appBar: MessageBoxAppBar(),
      body: Container(
        decoration: CustomDecorations.buildGradientBoxDecoration(
          Colors.blue,
          Colors.red,
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return AllMessagesWidget(controller);
          }
        }),
      ),
    );
  }

  ListView AllMessagesWidget(StudentMessageController controller) {
    return ListView.builder(
      itemCount: controller.messageLists.length,
      itemBuilder: (context, index) {
        final message = controller.messageLists[index];
        String initials = "";
        if (message['name'].isNotEmpty) {
          initials += message['name'][0];
        }
        if (message['surname'].isNotEmpty) {
          initials += message['surname'][0];
        }
        return InkWell(
          onTap: () {
            controller.getMessageStreamWhileCondition.value = true;
            Get.to(() => StudentChatPage(
                  receiverId: message['user_id'],
                  receiverName: message['name'],
                ),transition: Transition.rightToLeft);
          },
          child: Container(
            decoration: CustomDecorations.buildGradientBoxDecoration(
              Colors.lightBlueAccent,
              Colors.purpleAccent,
            ),
            margin: const EdgeInsets.all(18),
            padding: const EdgeInsets.all(15),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
                child: Text(initials),
              ),
              title: Text(
                '${message['name']} ${message['surname']}',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                message['email'],
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: deleteMessages(context, controller, message['user_id']),
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar MessageBoxAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.blue,
      title: const Text(
        "Mesaj Listesi",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  IconButton deleteMessages(BuildContext context,
      StudentMessageController messageController, int receiverId) {
    return IconButton(
      icon: const Icon(
        Icons.delete_outline_outlined,
        color: Colors.white,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Silme İşlemi'),
              content: const Text('Silmek istediğinize emin misiniz?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Hayır'),
                  onPressed: () {
                    // Dialog'u kapat
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Evet'),
                  onPressed: () async {
                    await messageController.deleteAllMessages(
                        int.parse(Get.find<LoginController>().user_id.value),
                        receiverId,
                        Get.find<LoginController>().token.value);

                    await messageController.messageList(
                      int.parse(Get.find<LoginController>().user_id.value),
                      Get.find<LoginController>().token.value,
                    );

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
