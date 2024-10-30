import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/lecturer/get_studentrequest.dart';
import 'package:schoolworkspro_app/response/lecturer/progress_student_response.dart';
import 'package:schoolworkspro_app/services/lecturer/viewstudents_service.dart';

import '../../../../api/repositories/lecturer/modules_repository.dart';
import '../../../../config/api_response_config.dart';
import '../../../../constants/colors.dart';
import '../view_model/modules_view_model.dart';

class ViewStudents extends StatefulWidget {
  final module_slug;
  final module_title;
  const ViewStudents({Key? key, this.module_slug, this.module_title})
      : super(key: key);

  @override
  _ViewStudentsState createState() => _ViewStudentsState();
}

class _ViewStudentsState extends State<ViewStudents> {
  Future<ProgressStudentResponse>? progress_student;
  Icon cusIcon = Icon(Icons.search);
  late Widget cusSearchBar;
  TextEditingController? _searchController;
  List<dynamic> _list = <dynamic>[];
  List<dynamic> _listForDisplay = <dynamic>[];

  late ModuleViewModel _provider;

  @override
  void initState() {
    // TODO: implement initState
    cusSearchBar = Text(
      widget.module_title,
      style: TextStyle(color: white),
    );
    getData();
    super.initState();
  }

  getData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<ModuleViewModel>(context, listen: false);
      final data = Getstudentrequest(moduleSlug: widget.module_slug);
      _provider.fetchStudentForModule(data).then((_) {
        if (_provider.studentOnlyForModuleList.allProgress != null) {
          print(
              "No data::::${_provider.studentOnlyForModuleList.allProgress!}");
          for (int i = 0;
              i < _provider.studentOnlyForModuleList.allProgress!.length;
              i++) {
            setState(() {
              _list.add(_provider.studentOnlyForModuleList.allProgress![i]);
              _listForDisplay = _list;
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (cusIcon.icon == Icons.search) {
                      cusIcon = const Icon(
                        Icons.cancel,
                        color: white,
                      );
                      cusSearchBar = TextField(
                        autofocus: true,
                        textInputAction: TextInputAction.go,
                        controller: _searchController,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(color: white),
                            border: InputBorder.none,
                            hintText: "Search by name..."),
                        onChanged: (text) {
                          setState(() {
                            _listForDisplay = _list.where((list) {
                              var fullname =
                                  list['firstname'] + ' ' + list['lastname'];
                              var itemName = fullname.toLowerCase();
                              return itemName.contains(text);
                            }).toList();
                          });
                        },
                      );
                    } else {
                      this.cusIcon = Icon(Icons.search);
                      this.cusSearchBar = Text(
                        widget.module_title,
                        style: TextStyle(color: white),
                      );
                    }
                  });
                },
                icon: cusIcon)
          ],
          title: cusSearchBar,
        ),
        body: Consumer<ModuleViewModel>(builder: (context, module, child) {
          return isLoading(module.studentOnlyForModuleListApiResponse)
              ? const Center(child: CupertinoActivityIndicator())
              : module.studentOnlyForModuleList.allProgress == null ||
                      module.studentOnlyForModuleList.allProgress!.isEmpty
                  ? Column(
                      children: [
                        Image.asset("assets/images/no_content.PNG"),
                      ],
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        return _listItem(index);
                      },
                      itemCount: _listForDisplay.length,
                    );
        }));
  }

  _listItem(index) {
    var fullname = _listForDisplay[index]['firstname'] +
        ' ' +
        _listForDisplay[index]['lastname'];
    print(_listForDisplay[index]);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularPercentIndicator(
              radius: 35.0,
              lineWidth: 6.0,
              percent: (_listForDisplay[index]['progress'].toDouble() / 100),
              center: Text(
                _listForDisplay[index]['progress'].toString() +
                    "%",
                style: TextStyle(fontSize: 12),
              ),
              progressColor: _listForDisplay[index]['progress']! >= 80
                  ? Colors.green
                  : _listForDisplay[index]['progress']! >= 70 &&
                  _listForDisplay[index]['progress']! < 80
                  ? Colors.yellow
                  : Colors.red,
              animationDuration: 100,
              animateFromLastPercent: true,
              backgroundColor: grey_200,
              animation: true,
              circularStrokeCap: CircularStrokeCap.butt,
            ),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'Name: ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: black),
                      children: [
                        TextSpan(
                          text: fullname,
                          style: const TextStyle(
                              fontWeight:
                              FontWeight.normal,
                              color: black),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 5,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Student ID: ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: black),
                      children: [
                        TextSpan(
                          text:  _listForDisplay[index]['username'],
                          style: const TextStyle(
                              fontWeight:
                              FontWeight.normal,
                              color: black),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 5,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Batch: ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: black),
                      children: [
                        TextSpan(
                          text: _listForDisplay[index]['batch'],
                          style: const TextStyle(
                              fontWeight:
                              FontWeight.normal,
                              color: black),
                        ),
                      ]),
                ),

            ],),
          ],
        )
      ),
    );
  }
}
