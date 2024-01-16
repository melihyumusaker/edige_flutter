class ApiConfig {
  static const String baseUrl = 'http://192.168.1.43:8080';
  static const String signInEndpoint = '/api/v1/auth/signin';
  static const String getStudentIdByUserId = '/students/getStudentIdByUserId';
  static const String getStudentById = '/students/getStudentById';
  static const String getWeeklyProgramByStudentId =
      '/weekly-programs/getWeeklyProgramByStudentId';
  static const String getTeachersByStudentType =
      '/teachers/getTeachersByStudentType';
  static const String setStudentsEnneagramResult =
      '/students/setStudentsEnneagramResult';
  static const String getStudentTrialExams =
      '/trial-exams/getStudentTrialExams';
}
