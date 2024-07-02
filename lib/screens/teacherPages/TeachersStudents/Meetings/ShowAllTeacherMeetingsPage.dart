// ignore_for_file: file_names

import 'package:edige/controllers/MeetingController.dart';
import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/Meetings/MeetingDetailPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/Meetings/UpdateMeetingPage.dart';
import 'package:edige/utils/CustomDecorations.dart';
import 'package:edige/utils/Helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShowAllTeacherMeetingsPage extends StatelessWidget {
  const ShowAllTeacherMeetingsPage({super.key});

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
      appBar: AppBar(
        title: Text(
          'Toplantılar',
          style: TextStyle(
            color: Colors.white,
            fontSize: scaleWidth(25, screenWidth),
          ),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        centerTitle: true,
      ),
      body: Container(
        decoration: CustomDecorations.buildGradientBoxDecoration(
            const Color(0xFF4A90E2), const Color(0xFF50E3C2)),
        child: Obx(() {
          if (meetingController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (meetingController.teacherAllMeetings.isEmpty) {
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
            itemCount: meetingController.teacherAllMeetings.length,
            itemBuilder: (context, index) {
              final meeting = meetingController.teacherAllMeetings[index];
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListTile(
                              leading: Icon(
                                Icons.event,
                                color: Colors.blue,
                                size: scaleWidth(24, screenWidth),
                              ),
                              title: Text(
                                meeting['title'] ?? 'Bilinmiyor',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: scaleWidth(15, screenWidth),
                                ),
                              ),
                              trailing: Icon(Icons.info_outline,
                                  color: Colors.blue,
                                  size: scaleWidth(24, screenWidth)),
                              onTap: () {
                                showDescriptionDialog(
                                    context,
                                    meeting['description'],
                                    scaleWidth(16, screenWidth));
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
                                  await meetingController.deleteMeeting(
                                      meeting['meeting_id'],
                                      Get.find<TeacherController>()
                                          .token
                                          .value);

                                  meetingController.getTeacherAllMeetings(
                                    Get.find<TeacherController>()
                                        .teacherId
                                        .value,
                                    Get.find<TeacherController>().token.value,
                                  );
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
                                        studentId: meeting['relation_id']
                                            ['student_id']['student_id'],
                                      ),
                  transition: Transition
                      .rightToLeft);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: scaleHeight(12, screenHeight)),
                      iconWithText(
                          Icons.calendar_today,
                          Helper.formatDate(
                              meeting['start_day'] ?? 'Bilinmiyor'),
                          scaleWidth(16, screenWidth),
                          scaleWidth(16, screenWidth),
                          Colors.blue),
                      SizedBox(height: scaleHeight(12, screenHeight)),
                      iconWithText(
                          Icons.access_time,
                          Helper.formatTime(
                              meeting['start_hour'] ?? 'Bilinmiyor'),
                          scaleWidth(16, screenWidth),
                          scaleWidth(16, screenWidth),
                          Colors.blue),
                      SizedBox(height: scaleHeight(12, screenHeight)),
                      iconWithText(
                          Icons.location_on,
                          meeting['location'] ?? 'Yer belirtilmemiş',
                          scaleWidth(16, screenWidth),
                          scaleWidth(16, screenWidth),
                          Colors.blue),
                      SizedBox(height: scaleHeight(12, screenHeight)),
                      iconWithText(
                        Icons.person_2,
                        meeting['relation_id']['student_id']['user']['name'] +
                                " " +
                                meeting['relation_id']['student_id']['user']
                                    ['surname'] ??
                            'Kişi Belirtilmemiş',
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
                  transition: Transition
                      .rightToLeft
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

  String formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(parsedDate);
    } catch (e) {
      return 'Geçersiz tarih';
    }
  }
}
