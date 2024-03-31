// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:edige/controllers/LoginController.dart';
import 'package:edige/controllers/MessageControllers/StudentMessageController.dart';

class StudentChatPage extends StatefulWidget {
  final int receiverId;
  final String receiverName;
  const StudentChatPage(
      {super.key, required this.receiverId, required this.receiverName});

  @override
  State<StudentChatPage> createState() => _StudentChatPageState();
}

class _StudentChatPageState extends State<StudentChatPage> {
  late ScrollController _scrollController;
  late StudentMessageController messageController;
  late StreamController<List<dynamic>> messageStreamController;
  final TextEditingController _textEditingController = TextEditingController();

  bool _userIsAtBottom = true;

  void _scrollListener() {
    // Kullanıcı en altta mı kontrol et
    final isAtBottom = _scrollController.offset >=
        (_scrollController.position.maxScrollExtent - 50); // 50 pixel esneklik

    // Eğer kullanıcının konumu değiştiyse ve bu yeni durum önceki durumdan farklıysa, durumu güncelle
    if (isAtBottom != _userIsAtBottom) {
      setState(() {
        _userIsAtBottom = isAtBottom;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    messageStreamController = StreamController<List<dynamic>>.broadcast();
    messageController = Get.find<StudentMessageController>();
    messageController.getMessageStream(
      Get.find<LoginController>().token.value,
      int.parse(Get.find<LoginController>().user_id.value),
      widget.receiverId,
      messageStreamController,
    );
  }

  @override
  void dispose() {
    messageStreamController.close();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.receiverName),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            messageController.getMessageStreamWhileCondition.value = false;
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.red],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                StreamBuilder<List<dynamic>>(
                  stream: messageStreamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Bir hata oluştu: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Görüntülenecek mesaj yok'));
                    } else {
                      if (snapshot.connectionState == ConnectionState.active) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          // Kullanıcı son mesaja bakıyorsa, otomatik olarak en alta kaydır
                          if (_scrollController.hasClients && _userIsAtBottom) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration:const  Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                            );
                          }
                        });
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var message = snapshot.data![index];
                          return message['sender_id'] ==
                                  int.parse(
                                      Get.find<LoginController>().user_id.value)
                              ? _buildSenderMessage(message)
                              : _buildReceiverMessage(message);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                          hintText: 'Mesajınızı buraya yazın',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Material(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30.0),
                      onTap: () async {
                        await Get.find<StudentMessageController>().sendMessage(
                            int.parse(
                                Get.find<LoginController>().user_id.value),
                            widget.receiverId,
                            _textEditingController.text,
                            Get.find<LoginController>().token.value);
                        _textEditingController.text = "";
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSenderMessage(dynamic message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Siz',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  message['message_content'],
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              Text(
                _formatDateTime(message['send_date']),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiverMessage(dynamic message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.receiverName,
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  message['message_content'],
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              Text(
                _formatDateTime(message['send_date']),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final formattedDate = DateFormat.yMd().add_jm().format(dateTime);
    return formattedDate;
  }
}
