// ignore_for_file: use_build_context_synchronously, file_names, must_be_immutable, library_private_types_in_public_api, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:edige/controllers/MeetingController.dart';
import 'package:flutter/material.dart';
import 'package:edige/utils/CustomDecorations.dart';
import 'package:get/get.dart';

class MeetingDetailPage extends StatefulWidget {
  var meetingId;
  MeetingDetailPage({
    Key? key,
    required this.meetingId,
  }) : super(key: key);

  @override
  _MeetingDetailPageState createState() => _MeetingDetailPageState();
}

class _MeetingDetailPageState extends State<MeetingDetailPage> {
  bool? studentAttended;
  bool? parentAttended;
  final TextEditingController commentController = TextEditingController();

  bool get isFormValid =>
      studentAttended != null &&
      parentAttended != null &&
      commentController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    // Ekran boyutlarını al
    final screenSize = MediaQuery.of(context).size;
    final meetingController = Get.find<MeetingController>();

    // Responsive padding ve boyutları hesapla
    final padding = screenSize.width * 0.04;
    final spacing = screenSize.height * 0.02;
    final buttonPaddingHorizontal = screenSize.width * 0.08;
    final buttonPaddingVertical = screenSize.height * 0.02;
    final textFieldHeight = screenSize.height * 0.3;

    return Scaffold(
      appBar: MeetingDetailPageAppbar(),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: screenSize.height,
                decoration: CustomDecorations.buildGradientBoxDecoration(
                  const Color(0xFF4A90E2),
                  const Color(0xFF50E3C2),
                ),
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Öğrenci Toplantıya Katıldı mı?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: studentAttended,
                            onChanged: (bool? value) {
                              setState(() {
                                studentAttended = value;
                              });
                            },
                          ),
                          const Text('Evet',
                              style: TextStyle(color: Colors.white)),
                          Radio<bool>(
                            value: false,
                            groupValue: studentAttended,
                            onChanged: (bool? value) {
                              setState(() {
                                studentAttended = value;
                              });
                            },
                          ),
                          const Text('Hayır',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      SizedBox(height: spacing),
                      const Text(
                        'Veli Toplantıya Katıldı mı?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: parentAttended,
                            onChanged: (bool? value) {
                              setState(() {
                                parentAttended = value;
                              });
                            },
                          ),
                          const Text('Evet',
                              style: TextStyle(color: Colors.white)),
                          Radio<bool>(
                            value: false,
                            groupValue: parentAttended,
                            onChanged: (bool? value) {
                              setState(() {
                                parentAttended = value;
                              });
                            },
                          ),
                          const Text('Hayır',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      SizedBox(height: spacing),
                      const Text(
                        'Toplantı Yorumu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: spacing / 2),
                      SizedBox(
                        height: textFieldHeight,
                        child: TextField(
                          controller: commentController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            hintText: 'Yorumunuzu buraya yazın',
                            hintStyle: TextStyle(color: Colors.grey[700]),
                          ),
                          onChanged: (text) {
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(
                          height: 16), // Spacer yerine bir boşluk ekle
                      sendButton(meetingController, buttonPaddingHorizontal,
                          buttonPaddingVertical),
                    ],
                  ),
                ),
              ),
            ),
            if (meetingController.isLoading.value)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      }),
    );
  }

  Center sendButton(MeetingController meetingController,
      double buttonPaddingHorizontal, double buttonPaddingVertical) {
    return Center(
      child: ElevatedButton(
        onPressed: isFormValid
            ? () async {
                int studentAttendedValue = studentAttended == true ? 1 : 0;
                int parentAttendedValue = parentAttended == true ? 1 : 0;
                String comment = commentController.text;

                bool isSuccess = await meetingController.updateMeeting(
                  meetingId: widget.meetingId,
                  isStudentJoin: studentAttendedValue,
                  isParentJoin: parentAttendedValue,
                  teacherComment: comment,
                );

                 showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.of(context).pop(true);
                    });
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Row(
                        children: [
                          Icon(
                            isSuccess ? Icons.check_circle : Icons.error,
                            color: isSuccess ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(isSuccess ? 'Başarılı' : 'Başarısız'),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSuccess ? Icons.check_circle : Icons.error,
                            color: isSuccess ? Colors.green : Colors.red,
                            size: 80,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isSuccess
                                ? 'İşlem başarılı bir şekilde gerçekleştirildi.'
                                : 'İşlem başarısız oldu. Lütfen tekrar deneyin.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            : null,
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
            padding: EdgeInsets.symmetric(
              horizontal: buttonPaddingHorizontal,
              vertical: buttonPaddingVertical,
            ),
            child: const Text(
              'Gönder',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  AppBar MeetingDetailPageAppbar() {
    return AppBar(
      title: const Text(
        'Toplantı Sonrası',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF4A90E2),
      centerTitle: true,
    );
  }
}
