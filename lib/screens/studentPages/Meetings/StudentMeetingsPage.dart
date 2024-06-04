// ignore_for_file: non_constant_identifier_names, file_names

import 'package:edige/controllers/MeetingController.dart';
import 'package:edige/utils/CustomDecorations.dart';
import 'package:edige/utils/Helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentMeetingsPage extends StatelessWidget {
  const StudentMeetingsPage({super.key});

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

  double scaleHeight(double size, double screenHeight) =>
      size * screenHeight / 812;
  double scaleWidth(double size, double screenWidth) =>
      size * screenWidth / 375;

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
      appBar: StudentMeetingsPageAppBar(screenWidth),
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

              return Stack(
                children: [
                  Card(
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
                          titleAndDescription(screenWidth, meeting, context),
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
                          Text(
                            'Oluşturulma Tarihi: ${Helper.formatDate(meeting['createdAt'] ?? 'Bilinmiyor')}',
                            style: TextStyle(
                              fontSize: scaleWidth(14, screenWidth),
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (meeting["is_shown"] == 0) NewMeetingText(),
                ],
              );
            },
          );
        }),
      ),
    );
  }

  Row titleAndDescription(
      double screenWidth, Map<String, dynamic> meeting, BuildContext context) {
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
      ],
    );
  }

  Positioned NewMeetingText() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Text(
          'YENİ',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  AppBar StudentMeetingsPageAppBar(double screenWidth) {
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
    );
  }
}
