import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/extension/sizebox_ex.dart';
import 'package:schoolworkspro_app/routes/route_generator.dart';
import '../../../../api/repositories/collaboration_repo.dart';
import '../../../../config/api_response_config.dart';
import '../../../../helper/custom_loader.dart';
import '../../../../response/module_group_collaboration.dart';
import '../../../student/available_collaboration/available_collaboration_page.dart';
import '../../../student/available_collaboration/collaboration_tab_page.dart';
import '../../../student/available_collaboration/collaboration_view_model.dart';
import '../../../widgets/snack_bar.dart';

class LecturerCollaborationScreen extends StatefulWidget {
  final String moduleId;
  const LecturerCollaborationScreen({Key? key, required this.moduleId})
      : super(key: key);

  @override
  State<LecturerCollaborationScreen> createState() =>
      _LecturerCollaborationScreenState();
}

class _LecturerCollaborationScreenState
    extends State<LecturerCollaborationScreen> {
  String? selectedBatch;

  Future<void> refreshData(CollaborationViewModel collaborationVM) async {

    String params = "${widget.moduleId}?batch=$selectedBatch";
    collaborationVM.fetchAvailableCollaboration(params);
  }

  BuildContext ? _context;
  @override
  void initState() {
    // TODO: implement initState
    _context = context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CommonViewModel, CollaborationViewModel>(
        builder: (context, commonVm, collaborationVM, child) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: RefreshIndicator(
            onRefresh: ()=>refreshData(collaborationVM),
            child: ListView(
              shrinkWrap: true,
              children: [
                DropdownButtonFormField(
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    hintText: 'select batch/section',
                  ),
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  items: commonVm.batchArr.map((pt) {
                    return DropdownMenuItem(
                      value: pt,
                      child: Text(
                        pt,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      selectedBatch = newVal as String?;

                      var batch = newVal?.split(" ").join("%20");
                      String params = "${widget.moduleId}?batch=$batch";
                      collaborationVM.fetchAvailableCollaboration(params);
                    });
                  },
                  value: selectedBatch,
                ),
                10.sH,
                selectedBatch == null
                    ? const Center(child: Text(" Choose batch to proceed"))
                    : isLoading(collaborationVM.availableCollaborationApiResponse)
                        ? const Center(child: CupertinoActivityIndicator())
                        : collaborationVM.availableCollaboration.modules ==
                                    null ||
                                collaborationVM
                                    .availableCollaboration.modules!.isEmpty
                            ? Image.asset('assets/images/no_content.PNG')
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: collaborationVM
                                    .availableCollaboration.modules?.length,
                                itemBuilder: (context, index) {
                                  var tasks = collaborationVM
                                      .availableCollaboration.modules?[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  tasks?.groupName ?? "N?A",
                                                  maxLines: 10,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16),
                                                )),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      CollaborationTabScreen(
                                                                          moduleId: tasks?.id ??
                                                                              "")));
                                                        },
                                                        child: Container(
                                                          height: 32,
                                                          width: 32,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .blueAccent,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                          child: const Icon(
                                                            Icons.remove_red_eye,
                                                            size: 20,
                                                            color: Colors.white,
                                                          ),
                                                        )),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),


                                                    tasks?.isApproved ==
                                                        true
                                                        ? const SizedBox()
                                                        :
                                                    InkWell(
                                                      onTap:  () =>
                                                              checkApprovedStatus(
                                                                  context, collaborationVM,tasks),
                                                      child: Container(
                                                        height: 32,
                                                        width: 32,
                                                        decoration: BoxDecoration(
                                                            color:Colors.green,

                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(4)),
                                                        child: const Icon(
                                                            Icons.check,
                                                            size: 20,
                                                            color: Colors.white,
                                                            weight: 10),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "${tasks?.users?.length} Member(s)",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "Progress - ${tasks?.progress}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        )),
                                  );
                                })
              ],
            ),
          ),
        ),
      );
    });
  }

  void checkApprovedStatus(BuildContext context, CollaborationViewModel collaborationVM,ModuleElement ? element) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Approve Group'),
            content: const Text('Are you sure you want to approve this group?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No')),
              TextButton(
                onPressed: () async {
                  try {
                    customLoadStart();

                    var payload = {
                      "groupName":"${element?.groupName}",
                      "isApproved":"true"
                    };

                    print(payload);
                    final res =
                        await CollaborationRepository().updateApproveStatusGroups(payload,element?.id ?? "");

                    if (res.success == true) {
                      String params = "${widget.moduleId}?batch=$selectedBatch";
                      collaborationVM.fetchAvailableCollaboration(params);

                      RouteGenerator.goBack();
                      successSnackThis(
                          context: _context!,
                          content: Text("$selectedBatch group approved successfully!"));
                      customLoadStop();

                    } else {
                      errorSnackThis(
                          context: _context!,
                          content: const Text("Error approving group. Please try again later."));
                      RouteGenerator.goBack();
                      customLoadStop();
                    }
                  } on Exception catch (e) {
                    errorSnackThis(
                        context: context, content: Text(e.toString()));
                    customLoadStop();
                    RouteGenerator.goBack();
                  }
                },
                child: const Text('Yes, Approve it !'),
              )
            ],
          );
        });
    ;
  }
}
