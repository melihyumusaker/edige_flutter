// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, file_names, non_constant_identifier_names

import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/Meetings/CreateMeetingsPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/Meetings/MeetingDetailPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/Meetings/UpdateMeetingPage.dart';
import 'package:edige/utils/CustomDecorations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:edige/controllers/MeetingController.dart';

class ShowMeetingsPage extends StatelessWidget {
  var studentId;
  ShowMeetingsPage({super.key, required this.studentId});

  String formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(parsedDate);
    } catch (e) {
      return 'Geçersiz tarih';
    }
  }

  // Saat biçimlendirme fonksiyonu
  String formatTime(String time) {
    try {
      final DateTime parsedTime = DateTime.parse('1970-01-01T$time');
      final DateFormat formatter = DateFormat('HH:mm');
      return formatter.format(parsedTime);
    } catch (e) {
      return 'Geçersiz saat';
    }
  }

  // İkon ve metin kombinasyonunu oluşturan fonksiyon
  Widget iconWithText(IconData icon, String text, double iconSize,
      double fontSize, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: iconSize),
        SizedBox(width: iconSize / 3),
        Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
      ],
    );
  }

  // Boyut ölçekleme fonksiyonları
  double scaleHeight(double size, double screenHeight) =>
      size * screenHeight / 812;
  double scaleWidth(double size, double screenWidth) =>
      size * screenWidth / 375;

  // Bir liste öğesinin başlığını ve açıklamasını göstermek için
  void showDescriptionDialog(
      BuildContext context, String description, double fontSize) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Açıklama', style: TextStyle(fontSize: fontSize + 2)),
          content: Text(
            description,
            style: TextStyle(fontSize: fontSize),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Kapat', style: TextStyle(fontSize: fontSize)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final meetingController = Get.find<MeetingController>();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: ShowMeetingsPageAppbar(screenWidth),
      body: Container(
        decoration: CustomDecorations.buildGradientBoxDecoration(
            const Color(0xFF4A90E2), const Color(0xFF50E3C2)),
        child: Obx(() {
          if (meetingController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (meetingController.studentAndTeacherSpecialMeetings.isEmpty) {
            return Center(
              child: Text(
                'Görüntülenecek toplantı yok.',
                style: TextStyle(
                  fontSize: scaleWidth(20, screenWidth),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(scaleWidth(16.0, screenWidth)),
            itemCount:
                meetingController.studentAndTeacherSpecialMeetings.length,
            itemBuilder: (context, index) {
              final meeting =
                  meetingController.studentAndTeacherSpecialMeetings[index];
              final meetingDateTime = DateTime.parse(
                  "${meeting['start_day']} ${meeting['start_hour']}");
              final isPastMeeting = DateTime.now().isAfter(meetingDateTime) &&
                  meeting["is_student_join"] == 1;

              return Card(
                color: isPastMeeting ? Colors.blueGrey : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(scaleWidth(15.0, screenWidth)),
                ),
                elevation: scaleWidth(6.0, screenWidth),
                margin: EdgeInsets.symmetric(
                    vertical: scaleWidth(12.0, screenWidth)),
                child: Padding(
                  padding: EdgeInsets.all(scaleWidth(16.0, screenWidth)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isPastMeeting)
                        const Text(
                          "Toplantı Gerçekleştirildi",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      titleAndDeleleUpdateButtons(
                          screenWidth, meeting, context, meetingController),
                      SizedBox(height: scaleHeight(12, screenHeight)),
                      iconWithText(
                          Icons.calendar_today,
                          formatDate(meeting['start_day'] ?? 'Bilinmiyor'),
                          scaleWidth(16, screenWidth),
                          scaleWidth(16, screenWidth),
                          Colors.blue),
                      SizedBox(height: scaleHeight(12, screenHeight)),
                      iconWithText(
                          Icons.access_time,
                          formatTime(meeting['start_hour'] ?? 'Bilinmiyor'),
                          scaleWidth(16, screenWidth),
                          scaleWidth(16, screenWidth),
                          Colors.blue),
                      SizedBox(height: scaleHeight(12, screenHeight)),
                      iconWithText(
                        Icons.location_on,
                        meeting['location'] ?? 'Yer belirtilmemiş',
                        scaleWidth(16, screenWidth),
                        scaleWidth(16, screenWidth),
                        Colors.blue,
                      ),
                      SizedBox(height: scaleHeight(12, screenHeight)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          createdAtWidget(meeting, screenWidth),
                          IconButton(
                            onPressed: () {
                              Get.to(
                                () => MeetingDetailPage(
                                  meetingId: meeting["meeting_id"],
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_forward,
                              color: Colors.blueAccent,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Text createdAtWidget(Map<String, dynamic> meeting, double screenWidth) {
    return Text(
      'Oluşturulma Tarihi: ${formatDate(meeting['createdAt'] ?? 'Bilinmiyor')}',
      style: TextStyle(
        fontSize: scaleWidth(14, screenWidth),
        color: Colors.grey,
      ),
    );
  }

  Row titleAndDeleleUpdateButtons(
      double screenWidth,
      Map<String, dynamic> meeting,
      BuildContext context,
      MeetingController meetingController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListTile(
            leading: Icon(Icons.event,
                color: Colors.blue, size: scaleWidth(24, screenWidth)),
            title: Text(
              meeting['title'] ?? 'Bilinmiyor',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: scaleWidth(15, screenWidth),
              ),
            ),
            trailing: Icon(Icons.info_outline,
                color: Colors.blue, size: scaleWidth(24, screenWidth)),
            onTap: () {
              showDescriptionDialog(
                  context, meeting['description'], scaleWidth(16, screenWidth));
            },
          ),
        ),
        // Silme ve Düzenleme Butonları
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.redAccent,
                size: scaleWidth(24, screenWidth),
              ),
              onPressed: () async {
                await meetingController.deleteMeeting(meeting['meeting_id'],
                    Get.find<TeacherController>().token.value);

                meetingController.getStudentAndTeacherSpecialMeetings(
                    studentId,
                    Get.find<TeacherController>().teacherId.value,
                    Get.find<TeacherController>().token.value);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.orangeAccent,
                size: scaleWidth(24, screenWidth),
              ),
              onPressed: () {
                Get.to(() => UpdateMeetingPage(
                    meetingId: meeting['meeting_id'],
                    title: meeting['title'],
                    description: meeting['description'],
                    startDay: meeting['start_day'],
                    startHour: meeting['start_hour'],
                    location: meeting['location'],
                    studentId: studentId));
              },
            ),
          ],
        )
      ],
    );
  }

  AppBar ShowMeetingsPageAppbar(double screenWidth) {
    return AppBar(
      title: Text(
        'Toplantılar',
        style: TextStyle(
          color: Colors.white,
          fontSize: scaleWidth(25, screenWidth),
        ),
      ),
      backgroundColor: const Color(0xFF4A90E2),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.add,
            size: scaleWidth(30, screenWidth),
            color: Colors.lime,
          ),
          onPressed: () {
            Get.to(() => CreateMeetingsPage(studentId: studentId));
          },
        ),
      ],
    );
  }
}
