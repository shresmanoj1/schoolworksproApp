import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/response/viewlogistics_response.dart';
import 'package:schoolworkspro_app/services/viewlogistics_service.dart';
import '../../../api/api_response.dart';
import '../../response/viewinventoryrequest_response.dart';
import '../../services/inventoryrequest_service.dart';

class LogisticsViewModel extends ChangeNotifier {
  ApiResponse _requestLogisticsApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get requestLogisticsApiResponse => _requestLogisticsApiResponse;
  List<Logistic> _requestLogistics = <Logistic>[];
  List<Logistic> get requestLogistics => _requestLogistics;

  List<Logistic> _filterData = <Logistic>[];
  List<Logistic> get filterData => _filterData;

  int _logisticMainIndex = 0;
  int get logisticMainIndex => _logisticMainIndex;

  PageController _logisticMainController = PageController();
  PageController get logisticMainController => _logisticMainController;
  setMainIndex(int index) {
    _logisticMainIndex = index;
    notifyListeners();
  }

  setInitial(int index) {
    _logisticMainController = PageController(initialPage: index);
    setMainIndex(index);
    notifyListeners();
  }

  itemTapped(int index) {
    setMainIndex(index);
    _logisticMainController.jumpToPage(index);
    notifyListeners();
  }

  ///----------------------------------------------------------------------------------///

  int _logisticTabBarIndex = 0;
  int get logisticTabBarIndex => _logisticTabBarIndex;

  PageController _logisticTabController = PageController();
  PageController get logisticTabController => _logisticTabController;
  setLogisticTabIndex(int index) {
    _logisticTabBarIndex = index;
    notifyListeners();
  }

  setLogisticTabInitial(int index) {
    _logisticTabController = PageController(initialPage: index);
    setLogisticTabIndex(index);
    notifyListeners();
  }

  itemLogisticTabTapped(int index) {
    setLogisticTabIndex(index);
    _logisticTabController.jumpToPage(index);
    notifyListeners();
  }

  ///----------------------------------------------------------------------------------///

  int _inventoryTabBarIndex = 0;
  int get inventoryTabBarIndex => _inventoryTabBarIndex;

  PageController _inventoryTabController = PageController();
  PageController get inventoryTabController => _inventoryTabController;
  setInventoryTabIndex(int index) {
    _inventoryTabBarIndex = index;
    notifyListeners();
  }

  setInventoryTabInitial(int index) {
    _inventoryTabController = PageController(initialPage: index);
    setInventoryTabIndex(index);
    notifyListeners();
  }

  itemInventoryTabTapped(int index) {
    setInventoryTabIndex(index);
    _inventoryTabController.jumpToPage(index);
    notifyListeners();
  }

  /// ---------------------------------------------///

  String _popUpValue = "All";
  String get popUpValue => _popUpValue;

  updatePopUpValue(String data) {
    _popUpValue = data;
    if(data == "All"){
      _filterData = _requestLogistics;
      notifyListeners();
    }else{
      _filterData = _requestLogistics
          .where((element) => element.status.toString() == data.toString())
          .toList();
      notifyListeners();
    }

    notifyListeners();
  }


  Future<void> fetchMyLogistics() async {
    _requestLogisticsApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Viewlogisticsresponse res = await Viewlogisticservice().getlogistics();

      if (res.success == true) {
        _requestLogistics = res.logistics!;
        _filterData = res.logistics!;

        _requestLogisticsApiResponse =
            ApiResponse.completed(res.success.toString());

        notifyListeners();
      } else {
        _requestLogisticsApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRe :: $e");
      _requestLogisticsApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _requestInventoryApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get requestInventoryApiResponse => _requestInventoryApiResponse;
  Viewinventoryrequestresponse _requestInventory =
      Viewinventoryrequestresponse();
  Viewinventoryrequestresponse get requestInventory => _requestInventory;

  Future<void> fetchInventory() async {
    _requestInventoryApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Viewinventoryrequestresponse res =
          await ViewInventoryRequestService().getMyInventoryRequest();

      if (res.success == true) {
        _requestInventory = res;

        _requestInventoryApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _requestInventoryApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRe :: $e");
      _requestInventoryApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _logisticMainIndex = 0;
    _inventoryTabBarIndex = 0;
    _logisticTabBarIndex = 0;
    super.dispose();
  }
}
