// ignore_for_file: non_constant_identifier_names, file_names, use_build_context_synchronously

import 'package:edige/controllers/MessageController.dart';
import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/screens/teacherPages/TeacherMessage/StartChatPage.dart';
import 'package:edige/utils/CustomDecorations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({super.key});

  @override
  Widget build(BuildContext context) {
    final MessageController controller = Get.find<MessageController>();

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

  ListView AllMessagesWidget(MessageController controller) {
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
          onTap: () {},
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

  IconButton deleteMessages(BuildContext context,
      MessageController messageController, int receiverId) {
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
                        int.parse(Get.find<TeacherController>().user_id.value),
                        receiverId,
                        Get.find<TeacherController>().token.value);

                    await messageController.messageList(
                      int.parse(Get.find<TeacherController>().user_id.value),
                      Get.find<TeacherController>().token.value,
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

  AppBar MessageBoxAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.blue,
      title: const Text("Mesaj Listesi", style: TextStyle(color: Colors.white)),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Get.to(() => StartChatPage());
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.message,
                  color: Colors.blue, 
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
