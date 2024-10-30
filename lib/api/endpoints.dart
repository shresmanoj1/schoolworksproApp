// customer endpoints
class Endpoints {

  static const String login = "/verification/login";
  static const String lecturergetmodules = "/lecturers/find-by-email";
  static const String getInstitutiondetails = "/institutions/find-one";
  static const String getNotifications = "/notifications/all";
  static const String getNoticeLecturer = "/notices/all-notices/1";
  static const String getAllcourses = "/courses";
  static const String notices = "/notices/all-notices/";
  static const String moduleDetails = "/modules/check/lecturer-access";
  static const String assessmentStats = "/assessments/assessment-stats";
  static const String routineReminder = "/routines/remind-routine/";
  static const String disciplineHistory = "/disciplinary-history/";
  static const String addBookmarks = "/bookmarks/add";

  static const String assignment = "/assignments/module-assignments";
  static const String assignmentPlay = "/assignments/module-assignment";
  static const String assignmentSubmission = "/assignments/submit";
  static const String assignmentSubmissionReport = "api/result/by-submission-id/";

  static const String generateToken = "/library/digital/generate-url/";

  static const String getMyLearnings = "/users/my-learnings";
  static const String getMyLearningsNewApI = "/users/my-learnings-new";
  static const String modules = "/modules/";
  static const String filters = "/modules/learning-filters";
  static const String attendanceProgress = "/tracking/attendance-progress/";
  static const String lessonProgress = "/tracking/week-progress/";
  static const String supportTeacher = "/modules/get-lecturer-details-of/";
  static const String moduleAverageRating = "/ratings/average-rating/";
  static const String completedLessons = "/users/completed-lessons";
  static const String activityModule = "/assessments/my-assessments/";
  static const String lessonsForModules = "/lessons/";
  static const String lessonsContent = "/lessons/";
  static const String trackLessonStatus = "/tracking/lesson-status";
  static const String startLesson = "/tracking/start";
  static const String assessmentOfLesson = "/assessments/";
  static const String getSlides = "/lessons/get-files/all/";
  static const String comments = "/comments/";


  static const String getDigitalBooks = "/library/digital/all/";
  static const String getDigitalBookMarkedBooks = "/bookmarks/getMarkedBooks";


  static const String getMyDetails = "/users/my-details";
  static const String updateUserDetails = "/users/update-details";
  static const String authenticatedUserdetails = "/users/uid";
  static const String events = "/events/my-events";
  static const String getDocuments = "/users/get-documents";
  static const String addDocuments = "/users/upload-documents";
  static const String offenseLevel = "/disciplinary-history/currentLevel";
  static const String myJourney = "/users/getMyData";
  static const String isPublic = "/users/merge-data";
  static const String addJournal = "/journals/add";
  static const String updateJournal = "/journals/update/";
  static const String getJournal = "/journals/mine/";
  static const String deleteJournal = "/journals/delete/";
  static const String verifiedJournal = "/journals/verified";
  static const String weeklydetails = "/journals/single/";

  //Collaboration
  static const String moduleGroupCollaboration = "/module-group/collaborate/";
  static const String moduleGroupDetailTask = "/module-group/detail/";
  static const String collaborationGroup = "/module-group/detail";
  static const String allStudent = "/batch/";
  static const String createGroup = "/module-group/create-group";
  static const String createTaskGroup = "/module-group/tasks/create/";
  static const String updateTaskGroup = "/module-group/tasks/update/";
  static const String taskItemGroup = "/module-group/tasks/";
  static const String moduleGroupUpdateGroup = "/module-group/update-group/";
  static const String createSubGroup = "/module-group/sub-group/create/";
  static const String deleteGroup = "/module-group/sub-group/";
  static const String removeGroupMembers = "/module-group/permission";
  static const String availableCollaboration = "/assignments/collaborate";
  static const String allTasks = "/module-group/detail/";
  static const String addGroupMembers = "/module-group/add-members";

  static const String getAssignmentBatch = "/modules/assignment/";
  static const String likeJournal = "/journals/like/";
  static const String commentJournal = "/journals/comment/";

  static const String getAllQuiz = "/quiz/all/";
  static const String getQuiz = "/quiz/";
  static const String getmyanswer = "/question-answer/my-answer/";
  static const String addflagquestion = "/question-flag/flag";
  static const String getflagquestion = "/question-flag/flagged-question/";
  static const String postquizanswer = "/question-answer/submit";
  static const String postCodequizcheck = "/quiz/check-ce-exist/";
  static const String completeQuiz ="/quiz/completed/";
  static const String overview = "/question-answer/quiz-stats/";

  static const String kGetAllMessages = "/ai/chat/getAllChatMessages?username=";
  static const String kGetUserInputAdmin = "/ai/chat/getMessagesAPIAdmin";
  static const String kGetUserInputStudent = "/ai/chat/getMessagesAPI";
  static const String kDeleteChat = "/ai/chat/deleteChatHistory?username=";




}
