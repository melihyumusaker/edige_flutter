class ApiConfig {
  static const String baseUrl = 'http://192.168.1.56:8080';
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
}
