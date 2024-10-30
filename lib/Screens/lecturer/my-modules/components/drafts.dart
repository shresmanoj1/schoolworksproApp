import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/lesson_repository.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/lecturer/senddraft_response.dart';

import '../../../../constants/colors.dart';

class DraftScreen extends StatefulWidget {
  final data;
  const DraftScreen({Key? key, this.data}) : super(key: key);

  @override
  _DraftScreenState createState() => _DraftScreenState();
}

class _DraftScreenState extends State<DraftScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var _provider =
          Provider.of<LecturerCommonViewModel>(context, listen: false);
      _provider.setSlug(widget.data['moduleSlug']);
      _provider.fetchdraftcontent();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LecturerCommonViewModel, CommonViewModel>(
        builder: (context, value, common, child) {
      return isLoading(value.draftContentApiResponse) ? Center(child: CupertinoActivityIndicator(),) : value.drafts.isEmpty ? Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/no_content.PNG'),
        ],
      ) : ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          ...List.generate(value.drafts.length, (index) {
            var datas = value.drafts[index];
            return ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: datas.lessons?.length,
                itemBuilder: (context, j) {
                  var datas2 = datas.lessons?[j];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        ListTile(
                            subtitle: Text(datas2!.lessonTitle.toString()),
                            title: Text("Week ${datas.week}"),
                            trailing: datas2.lessonType == "quiz"
                                ? const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )
                                : InkWell(
                                    onTap: () async {
                                      try {
                                        final datas = {"type": "public"};

                                        SendDraftResponse res =
                                            await LessonRepository().senddrafts(
                                                datas2.lessonSlug.toString(),
                                                datas);
                                        if (res.success == true) {
                                          common.setLoading(true);

                                          snackThis(
                                              context: context,
                                              color: Colors.green,
                                              content: Text(
                                                  "Lesson released from draft"));
                                          value.setSlug(
                                              widget.data['moduleSlug']);
                                          value.fetchlessons();
                                          common.setLoading(false);
                                        } else {
                                          common.setLoading(true);
                                          snackThis(
                                              context: context,
                                              color: Colors.red,
                                              content: Text(
                                                  "Failed to release the lesson"));
                                          common.setLoading(false);
                                        }
                                      } on Exception catch (e) {
                                        common.setLoading(true);
                                        snackThis(
                                            context: context,
                                            color: Colors.red,
                                            content: Text(e.toString()));

                                        common.setLoading(false);
                                        // TODO
                                      }
                                    },
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.green,
                                    )))
                      ],
                    ),
                  );
                });
          })
        ],
      );
    });
  }
}
