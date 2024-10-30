import 'dart:convert';import 'package:flutter/material.dart';import 'package:schoolworkspro_app/api/api_response.dart';import 'package:schoolworkspro_app/response/parents/get_children_module.dart';import '../../../api/repositories/parent/children_homework_repo.dart';import '../../../response/parents/offline_task_response.dart';class ParentHomeworkViewModel extends ChangeNotifier {  ApiResponse _getChildrenModuleResponse =  ApiResponse.initial("Empty Data");  ApiResponse get getChildrenModuleResponse =>      _getChildrenModuleResponse;  ChildrenModuleResponse _module =  ChildrenModuleResponse();  ChildrenModuleResponse get module => _module;  Future<void> fetchModule(institution, username) async {    _getChildrenModuleResponse = ApiResponse.initial("Loading");    notifyListeners();    try {      print("USERNAME${username}");      ChildrenModuleResponse res =      await ChildrenHomeworkRepository().getModule(institution ,username);      print("REs:::::${res}");      if (res.success == true) {       print( res.toJson());        _module = res;        _getChildrenModuleResponse =            ApiResponse.completed(res.success.toString());        notifyListeners();      } else {        _getChildrenModuleResponse =            ApiResponse.error(res.success.toString());      }    } catch (e) {      print("VM CATCH ERR :: " + e.toString());      _getChildrenModuleResponse =          ApiResponse.error(e.toString());    }    notifyListeners();  }  ApiResponse _getOfflineTaskResponse =  ApiResponse.initial("Empty Data");  ApiResponse get getOfflineTaskResponse =>      _getOfflineTaskResponse;  List<OfflineTask>? _offlineTask =  <OfflineTask> [];  List<OfflineTask>? get offlineTask => _offlineTask;  Future<void> fetchOfflineTask(institution, moduleSlug, username) async {    _getOfflineTaskResponse = ApiResponse.initial("Loading");    notifyListeners();    try {      print("USERNAME${username}");      ChildrenOfflineTaskResponse res =      await ChildrenHomeworkRepository().getOfflineTask(institution, moduleSlug ,username);      print("REs:::::${res.toJson()}");      if (res.success == true) {        print( res.toJson());        _offlineTask = res.offlineTask;        _getOfflineTaskResponse =            ApiResponse.completed(res.success.toString());        notifyListeners();      } else {        _getOfflineTaskResponse =            ApiResponse.error(res.success.toString());      }    } catch (e) {      print("VM CATCH ERR :: " + e.toString());      _getOfflineTaskResponse =          ApiResponse.error(e.toString());    }    notifyListeners();  }}