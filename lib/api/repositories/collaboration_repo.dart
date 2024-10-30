
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:schoolworkspro_app/response/available_collaboration_response.dart';
import 'package:schoolworkspro_app/response/collaboration_task_group_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/create_sub_group_response.dart';
import 'package:schoolworkspro_app/response/create_task_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getstudentformarking_response.dart';
import 'package:schoolworkspro_app/response/remove_editor_response.dart';

import '../../response/collaboration_group_response.dart';
import '../../response/current_student_response.dart';
import '../../response/lecturer/getbatch_response.dart';
import '../../response/module_group_collaboration.dart';
import '../../response/task_item_response.dart';
import '../api.dart';
import '../endpoints.dart';

class CollaborationRepository {
  API api = API();

  Future<ModuleGroupCollaboration> getAvailableCollaboration(String id) async {
    dynamic response;
    ModuleGroupCollaboration res;
    try {
      response = await api.getWithToken(Endpoints.moduleGroupCollaboration + id);
      res = ModuleGroupCollaboration.fromJson(response);
      print(res.toJson());
    } catch (e) {
      print("CATCH getAvailableCollaboration:: ${e.toString()}");
      res = ModuleGroupCollaboration.fromJson(response);
    }
    return res;
  }

  Future<CollaborationGroupResponse> getGroup(String id) async {
    dynamic response;
    CollaborationGroupResponse res;
    try {
      response = await api.getWithToken("${Endpoints.collaborationGroup}$id");
      res = CollaborationGroupResponse.fromJson(response);
    } catch (e) {
      res = CollaborationGroupResponse.fromJson(response);
    }
    return res;
  }

  Future<GetStudentForMarkingResponse> getStudent(String batch) async {
    dynamic response;
    GetStudentForMarkingResponse res;
    try {
      response = await api.getWithToken("${Endpoints.allStudent}$batch/student");
      res = GetStudentForMarkingResponse.fromJson(response);
    } catch (e) {
      res = GetStudentForMarkingResponse.fromJson(response);
    }
    return res;
  }

  Future<CurrentStudentResponse> getCurrentStudent(String batch) async {
    dynamic response;
    CurrentStudentResponse res;
    try {
      response = await api.getWithToken("${Endpoints.allStudent}$batch/current-student");
      res = CurrentStudentResponse.fromJson(response);
    } catch (e) {
      res = CurrentStudentResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> createGroup(String data) async {

    dynamic response;
    Commonresponse res;
    try {
      response = await api.postDataWithToken(data ,Endpoints.createGroup);
      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<CollaborationTaskGroup> getAllTask(String id) async {
    dynamic response;
    CollaborationTaskGroup res;
    try {
      response = await api.getWithToken("${Endpoints.moduleGroupDetailTask}$id");
      res = CollaborationTaskGroup.fromJson(response);
    } catch (e) {
      res = CollaborationTaskGroup.fromJson(response);
    }
    return res;
  }

  Future<CreateSubGroupResponse> createSubGroup(String id, String data) async {
    dynamic response;
    CreateSubGroupResponse res;
    try {
      print("REQUEST DATA::${data}:::$id");
      response = await api.postDataWithToken(data ,"${Endpoints.createSubGroup}$id");
      res = CreateSubGroupResponse.fromJson(response);
    } catch (e) {
      res = CreateSubGroupResponse.fromJson(response);
    }
    return res;
  }

  Future<CreateTaskResponse> createTaskGroup(String id, String data, bool isUpdate) async {
    dynamic response;
    CreateTaskResponse res;
    try {
      response = isUpdate ? await api.putDataWithToken(data,"${Endpoints.updateTaskGroup}$id") :
      await api.postDataWithToken(data ,"${Endpoints.createTaskGroup}$id");
      print(isUpdate);
      print("${Endpoints.createTaskGroup}$id");
      res = CreateTaskResponse.fromJson(response);

    } catch (e) {
      print("ERROR::::${e.toString()}");
      res = CreateTaskResponse.fromJson(response);
    }
    return res;
  }

  Future<dynamic> deleteGroup(String id,) async {
    dynamic response;
    Commonresponse res;
    try {
      response = await api.deleteWithToken("${Endpoints.deleteGroup}$id");
      res = Commonresponse.fromJson(response);

    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<RemoveEditorResponse> removeEditor(String data) async {
    dynamic response;
    RemoveEditorResponse res;
    try {
      print(data);
      response = await api.putDataWithToken(data ,Endpoints.removeGroupMembers);
      res = RemoveEditorResponse.fromJson(response);
    } catch (e) {
      res = RemoveEditorResponse.fromJson(response);
    }
    return res;
  }

  Future<RemoveEditorResponse> addMember(String data) async {
    dynamic response;
    RemoveEditorResponse res;
    try {
      response = await api.putDataWithToken(data ,Endpoints.addGroupMembers);
      res = RemoveEditorResponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = RemoveEditorResponse.fromJson(response);
    }
    return res;
  }

  Future<dynamic> deleteMember(String id, String userId) async {
    dynamic response;
    Commonresponse res;
    try {
      response = await api.deleteWithToken("/module-group/$id/users/$userId");
      res = Commonresponse.fromJson(response);

    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<GetBatchResponse> getAssignmentBatch(String id) async {
    // Box box = HiveUtils.box;
    dynamic response;
    GetBatchResponse res;
    try {
      response = await api.getWithToken("${Endpoints.getAssignmentBatch}$id/batches");
      res = GetBatchResponse.fromJson(response);
      // await box.put(Endpoints.getAssignmentBatch, res.toJson());
    } catch (e) {
      // response = await box.get(Endpoints.getAssignmentBatch);
      res = GetBatchResponse.fromJson(response);
    }
    return res;
  }

  Future<TaskItemResponse> getTaskItem(String id) async {
    dynamic response;
    TaskItemResponse res;
    try {
      response = await api.getWithToken("${Endpoints.taskItemGroup}$id");
      res = TaskItemResponse.fromJson(response);
    } catch (e) {
      res = TaskItemResponse.fromJson(response);
    }
    return res;
  }

  Future<ModuleGroupCollaboration> updateApproveStatusGroups(Map<String,dynamic> data,String id) async {
    dynamic response;
    ModuleGroupCollaboration res;
    try {
      response = await api.putDataWithToken(jsonEncode(data),"${Endpoints.moduleGroupUpdateGroup}$id");
      res = ModuleGroupCollaboration.fromJson(response);
    } catch (e) {
      res = ModuleGroupCollaboration.fromJson(response);
    }
    return res;
  }
}
