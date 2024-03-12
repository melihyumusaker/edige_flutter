class ApiConfig {
  static const String baseUrl = 'http://192.168.1.75:8080';
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
  static const String messageList = '/message/messageList';
  static const String createMessage = '/message/createMessage';
  static const String deleteAllMessages = '/message/deleteAllMessages';
}
