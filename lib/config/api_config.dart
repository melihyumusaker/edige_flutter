class ApiConfig {
  static const String baseUrl = 'http://192.168.20.66:8080';
  static const String signInEndpoint = '/api/v1/auth/signin';
  static const String getStudentIdByUserId = '/students/getStudentIdByUserId';
  static const String getStudentById = '/students/getStudentById';
  static const String studentFinishHomework = '/courses/studentFinishHomework';
  static const String getWeeklyProgramByStudentId =
      '/weekly-programs/getWeeklyProgramByStudentId';
  static const String getTeachersByStudentType =
      '/teachers/getTeachersByStudentType';
  static const String setStudentsEnneagramResult =
      '/students/setStudentsEnneagramResult';
  static const String getStudentTrialExams =
      '/trial-exams/getStudentTrialExams';
  static const String getStudentsDoneCourses =
      '/students-courses/get-students-done-courses';
  static const String getStudentsNotDoneCourses =
      '/students-courses/get-students-not-done-courses';
  static const String getAllStudentsCourses =
      '/students-courses/get-all-students-courses';
  static const String unshownCourseNumber =
      "/students-courses/unshownCourseNumber";
  static const String getTeacherIdByUserId = '/teachers/getTeacherIdByUserId';
  static const String showStudents = '/teachers/showStudents';
  static const String getTeacherInfo = '/teachers/getTeacherInfo';
  static const String updateTeacherEnneagramTypeAndAbout =
      '/teachers/updateTeacherEnneagramTypeAndAbout';
  static const String getStudentTrialExamsByTeacher =
      '/trial-exams/getStudentTrialExamsByTeacher';
  static const String setStudentTrialExamResult =
      '/trial-exams/setStudentTrialExamResult';
  static const String addNewCourse = '/courses/addNewCourse';
  static const String addNewStudentCourse =
      '/students-courses/addNewStudentCourse';
  static const String createWeeklyProgram =
      '/weekly-programs/createWeeklyProgram';
  static const String updateWeeklyProgram =
      '/weekly-programs/updateWeeklyProgram';
  static const String deleteWeeklyProgram =
      '/weekly-programs/deleteWeeklyProgram';
  static const String deleteCourse = '/courses/deleteCourse';
  static const String updateCourse = '/courses/updateCourse';
  static const String deleteTrialExam = '/trial-exams/deleteTrialExam';
  static const String updateTrialExam = '/trial-exams/updateTrialExam';
  static const String updateTrialExamIsShownValue =
      '/trial-exams/updateTrialExamIsShownValue';
  static const String messageList = '/message/messageList';
  static const String createMessage = '/message/createMessage';
  static const String deleteAllMessages = '/message/deleteAllMessages';
  static const String messageHistory = '/message/messageHistory';
  static const String generateQRCode = '/qrSettings/generateQRCode';
  static const String saveStudentRecords = '/qrSettings/saveStudentRecords';
  static const String grades = '/lessons/grades';
  static const String lessonNames = '/lessons/lessonNames';
  static const String sublessonNames = '/lessons/sublessonNames';
  static const String sublessonNameDetails = '/lessons/sublessonNameDetails';
  static const String getAllLessons = '/lessons/getAllLessons';
  static const String getStudentAndTeacherSpecialMeetings =
      '/meetings/getStudentAndTeacherSpecialMeetings';
  static const String getTeacherAllMeetings = '/meetings/getTeacherAllMeetings';
  static const String createMeeting = '/meetings/createMeeting';
  static const String deleteMeeting = '/meetings/deleteMeeting';
  static const String updateMeeting = '/meetings/updateMeeting';
  static const String forgetPassword = '/api/v1/auth/forget-password';
  static const String countUnshown = '/trial-exams/countUnshown';
  static const String countUnshownMeetings = '/meetings/countUnshown';
  static const String getStudentTotalRecord = '/qrSettings/getStudentTotalRecord';
  static const String getNotifStudentByStudentId = '/notifStudent/getNotifStudentByStudentId';
   static const String getUnseenNotifNumber = '/notifStudent/getUnseenNotifNumber';
      static const String setAllNotifsUnshownValue1 = '/notifStudent/setAllNotifsUnshownValue1';
}
